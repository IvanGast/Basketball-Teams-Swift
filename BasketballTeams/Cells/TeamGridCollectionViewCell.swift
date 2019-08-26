//
//  TeamGridCollectionViewCell.swift
//  BasketballTeams
//
//  Created by Ivan on 16/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit

class TeamGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var titleGrid: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }
    
    func setup(_ title: String, _ image: UIImage, _ id: String) {
        if title == "" {
            titleGrid.text = "Not available"
        } else {
            titleGrid.text = title
        }
        imageLogo.image = image
        accessibilityIdentifier = id
    }
}
