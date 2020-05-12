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
var controller: UIViewController?

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
    webViewParameters = MSALWebviewParameters(authPresentationViewController: GamesViewController())
}

func getGraphEndpoint() -> String {
    return kGraphEndpoint.hasSuffix("/") ? (kGraphEndpoint + "v1.0/me/") : (kGraphEndpoint + "/v1.0/me/");
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

