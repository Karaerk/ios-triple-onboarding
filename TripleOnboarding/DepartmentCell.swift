//
//  DepartmentCell.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 24/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class DepartmentCell: UITableViewCell {
    
    @IBOutlet weak var departImage: UIImageView!
    @IBOutlet weak var departTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

