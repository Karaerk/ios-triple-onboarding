//
//  Login.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 12/05/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import Foundation
import MSAL

let kClientID = "482d1771-92c7-4fd7-8022-cfd17cb84866"
let kRedirectUri = "msauth.com.wearetriple.TripleOnboarding://auth"
let kAuthority = "https://login.microsoftonline.com/organizations"
let kGraphEndpoint = "https://graph.microsoft.com/"

let kScopes: [String] = ["user.read"] // request permission to read the profile of the signed-in user

var accessToken = String()
var applicationContext : MSALPublicClientApplication?
var webViewParameters : MSALWebviewParameters?
var currentAccount: MSALAccount?

//var loginSucces = false

func appCameToForeGround(notification: Notification) {
    loadCurrentAccount()
}

func loadMSAL() {
    do {
        try initMSAL()
    } catch let error {
        print("Unable to create Application Context \(error)")
    }
    loadCurrentAccount()
}

func loginSucces() -> Bool {
    if currentAccount != nil {
        return true
    } else { return false }
}

func initMSAL() throws {
    
    guard let authorityURL = URL(string: kAuthority) else {
        updateLogging(text: "Unable to create authority URL")
        return
    }
    
    let authority = try MSALAADAuthority(url: authorityURL)
    
    let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: nil, authority: authority)
    applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
    initWebViewParams()
}

func initWebViewParams() {
    webViewParameters = MSALWebviewParameters(authPresentationViewController: LoginController())
}

func getGraphEndpoint() -> String {
    return kGraphEndpoint.hasSuffix("/") ? (kGraphEndpoint + "v1.0/me/") : (kGraphEndpoint + "/v1.0/me/");
}

func callLoginAPI(_ sender: UIButton) {
    
    loadCurrentAccount { (account) in
        
        guard let currentAccount = account else {
            
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            acquireTokenInteractively()
            return
        }
        
        acquireTokenSilently(currentAccount)
    }
}

typealias AccountCompletion = (MSALAccount?) -> Void

func loadCurrentAccount(completion: AccountCompletion? = nil) {
    
    guard let applicationContext = applicationContext else { return }
    
    let msalParameters = MSALParameters()
    msalParameters.completionBlockQueue = DispatchQueue.main
    
    applicationContext.getCurrentAccount(with: msalParameters, completionBlock: { (currentAccount, previousAccount, error) in
        
        if let error = error {
            updateLogging(text: "Couldn't query current account with error: \(error)")
            return
        }
        
        if let currentAccount = currentAccount {
            updateLogging(text: "Found a signed in account \(String(describing: currentAccount.username)). Updating data for that account...")
            
            updateCurrentAccount(account: currentAccount)
            
            if let completion = completion {
                completion(currentAccount)
            }
            
            return
        }
        
        updateLogging(text: "Account signed out. Updating UX")
        accessToken = ""
        updateCurrentAccount(account: nil)
        
        if let completion = completion {
            completion(nil)
        }
    })
}

func acquireTokenInteractively() {
    
    guard let applicationContext = applicationContext else { return }
    guard let webViewParameters = webViewParameters else { return }
    
    // #1
    let parameters = MSALInteractiveTokenParameters(scopes: kScopes, webviewParameters: webViewParameters)
    parameters.promptType = .selectAccount
    
    // #2
    applicationContext.acquireToken(with: parameters) { (result, error) in
        
        // #3
        if let error = error {
            
            updateLogging(text: "Could not acquire token: \(error)")
            return
        }
        
        guard let result = result else {
            
            updateLogging(text: "Could not acquire token: No result returned")
            return
        }
        
        // #4
        accessToken = result.accessToken
        updateLogging(text: "Access token is \(accessToken)")
        updateCurrentAccount(account: result.account)
        getContentWithToken()
    }
}

func acquireTokenSilently(_ account : MSALAccount!) {
    
    guard let applicationContext = applicationContext else { return }
    
    /**
     
     Acquire a token for an existing account silently
     
     - forScopes:           Permissions you want included in the access token received
     in the result in the completionBlock. Not all scopes are
     guaranteed to be included in the access token returned.
     - account:             An account object that we retrieved from the application object before that the
     authentication flow will be locked down to.
     - completionBlock:     The completion block that will be called when the authentication
     flow completes, or encounters an error.
     */
    
    let parameters = MSALSilentTokenParameters(scopes: kScopes, account: account)
    
    applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
        
        if let error = error {
            
            let nsError = error as NSError
            
            // interactionRequired means we need to ask the user to sign-in. This usually happens
            // when the user's Refresh Token is expired or if the user has changed their password
            // among other possible reasons.
            
            if (nsError.domain == MSALErrorDomain) {
                
                if (nsError.code == MSALError.interactionRequired.rawValue) {
                    
                    DispatchQueue.main.async {
                        acquireTokenInteractively()
                    }
                    return
                }
            }
            
            updateLogging(text: "Could not acquire token silently: \(error)")
            return
        }
        
        guard let result = result else {
            
            updateLogging(text: "Could not acquire token: No result returned")
            return
        }
        
        accessToken = result.accessToken
        updateLogging(text: "Refreshed Access token is \(accessToken)")
        //self.updateSignOutButton(enabled: true)
        getContentWithToken()
    }
}

func getContentWithToken() {
    
    // Specify the Graph API endpoint
    let graphURI = getGraphEndpoint()
    let url = URL(string: graphURI)
    var request = URLRequest(url: url!)
    
    // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        
        if let error = error {
            updateLogging(text: "Couldn't get graph result: \(error)")
            return
        }
        
        guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
            
            updateLogging(text: "Couldn't deserialize result JSON")
            return
        }
        
        updateLogging(text: "Result from Graph: \(result))")
        
    }.resume()
}

func signOut(_ sender: UIButton) {
    
    guard let applicationContext = applicationContext else { return }
    
    guard let account = currentAccount else { return }
    
    do {
        
        /**
         Removes all tokens from the cache for this application for the provided account
         
         - account:    The account to remove from the cache
         */
        
        let signoutParameters = MSALSignoutParameters(webviewParameters: webViewParameters!)
        signoutParameters.signoutFromBrowser = false // set this to true if you also want to signout from browser or webview
        
        applicationContext.signout(with: account, signoutParameters: signoutParameters, completionBlock: {(success, error) in
            
            if let error = error {
                updateLogging(text: "Couldn't sign out account with error: \(error)")
                return
            }
            
            updateLogging(text: "Sign out completed successfully")
            accessToken = ""
            updateCurrentAccount(account: nil)
        })
        
    }
}

func updateLogging(text : String) {
    
    if Thread.isMainThread {
        print(text)
    } else {
        DispatchQueue.main.async {
            print(text)
        }
    }
}

func updateCurrentAccount(account: MSALAccount?)  {
    currentAccount = account
}

func getDeviceMode(_ sender: AnyObject) {
    
    if #available(iOS 13.0, *) {
        applicationContext?.getDeviceInformation(with: nil, completionBlock: { (deviceInformation, error) in
            
            guard let deviceInfo = deviceInformation else {
                updateLogging(text: "Device info not returned. Error: \(String(describing: error))")
                return
            }
            
            let isSharedDevice = deviceInfo.deviceMode == .shared
            let modeString = isSharedDevice ? "shared" : "private"
            updateLogging(text: "Received device info. Device is in the \(modeString) mode.")
        })
    } else {
        updateLogging(text: "Running on older iOS. GetDeviceInformation API is unavailable.")
    }
}
