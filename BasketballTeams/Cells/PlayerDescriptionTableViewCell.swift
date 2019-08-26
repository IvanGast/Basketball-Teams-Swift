//
//  PlayerDescriptionTableViewCell.swift
//  BasketballTeams
//
//  Created by Ivan on 08/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit

class PlayerDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var desciprtionLabel: UILabel!
    
    func setup(_ description: String, _ id: String) {
        desciprtionLabel.numberOfLines = 0
        desciprtionLabel.text = description
        accessibilityIdentifier = id
    }
}
