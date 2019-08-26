//
//  TeamCollectionViewCell.swift
//  BasketballTeams
//
//  Created by Ivan on 05/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit
class TeamCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desciptionTeam: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }
    
    func setup(_ team: Team?, _ image: UIImage, _ id: String) {
        if team?.country == "", team?.name == "" {
            title.text = "Not available"
        } else {
            title.text = (team?.country ?? "") + " - " + (team?.name ?? "")
        }
        desciptionTeam.text = team?.descriptionTeam ?? ""
        accessibilityIdentifier = id
        badgeImage.image = image
    }
}
