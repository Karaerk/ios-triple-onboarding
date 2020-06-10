//
//  VideoController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 21/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import AVKit
import AVFoundation

struct VideoContent {
    var title: String!
    var url: URL!
    var image: UIImage!
}

class VideoController: UITableViewController {
    
    private var ref: DatabaseReference!
    private var videoContent = [VideoContent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateContent()
    }
    
    func updateContent(){
        ref = Database.database().reference().child("video")
        
        ref.observe(.childAdded) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            let videoTitle = (firebaseResponse["title"] as? String)!
            let videoUrl = URL(string: (firebaseResponse["url"] as? String)!)
            
            self.getThumbnailImageFromVideoUrl(url: videoUrl!) { (thumbImage) in
                self.videoContent.append(VideoContent(title: videoTitle, url: videoUrl, image: thumbImage))
                self.tableView.reloadData()
            }
        }
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 2)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoContent.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! ImageTitleCell
        let content = videoContent[indexPath.row]
        cell.titleLabel.text = content.title
        cell.imageViewUI.image = content.image
        cell.playButton.image = #imageLiteral(resourceName: "play_button")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = videoContent[indexPath.row]
        playVideo(url: content.url)
    }
    
}
