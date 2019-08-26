//
//  PlayerTableViewCell.swift
//  BasketballTeams
//
//  Created by Ivan on 05/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerLabel: UILabel!
    
    func setup(_ image: UIImage, _ name: String, _ position: String, _ id: String) {
        playerImage.image = image
        playerImage.layer.cornerRadius = playerImage.frame.height/2
        if position == "" {
            playerLabel.text = name
        } else {
            playerLabel.text = name + ", " + position
        }
        accessibilityIdentifier = id
    }
}
