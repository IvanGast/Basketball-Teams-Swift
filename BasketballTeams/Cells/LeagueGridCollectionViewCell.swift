//
//  ListGridCollectionViewCell.swift
//  BasketballTeams
//
//  Created by Ivan on 23/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit

class LeagueGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gridLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
    }
    
    func setup(_ image: UIImage, _ name: String) {
        gridLabel.text = name
    }
}
