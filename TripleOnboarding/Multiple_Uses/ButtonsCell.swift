//
//  ButtonsCell.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 10/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//
//  Used by FAQ and Facts

import UIKit

class ButtonsCell: UITableViewCell {

    private let pinkColor = UIColor(red: 236/255, green: 102/255, blue: 118/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateContent(text: String){
        self.textLabel?.text = text
        self.textLabel?.textAlignment = .center
        self.textLabel?.font = UIFont(name: "Dosis-Regular", size: 25)
        self.textLabel?.textColor = UIColor.white
        self.backgroundColor = pinkColor
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 20

    }


}
