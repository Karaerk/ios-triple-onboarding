//
//  ImageTitleCell.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 24/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

//Is used by Departments & Videos
class ImageTitleCell: UITableViewCell {
    
    @IBOutlet weak var imageViewUI: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var playButton: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

