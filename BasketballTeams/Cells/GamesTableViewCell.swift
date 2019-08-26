//
//  GamesTableViewCell.swift
//  BasketballTeams
//
//  Created by Ivan on 04/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit
class GamesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var oponentLabel: UILabel!
    @IBOutlet weak var VSLabel: UILabel!
    
    func setup(_ team: String,  _ date: String, _ oponent: String,_ id: String){
        teamLabel.text = team
        dateLabel.text = date
        if oponent == "Not available" {
            VSLabel.text = ""
            teamLabel.text = ""
        }
        oponentLabel.text = oponent
        accessibilityIdentifier = id
    }
}
