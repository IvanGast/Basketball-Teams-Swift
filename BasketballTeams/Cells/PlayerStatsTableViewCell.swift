//
//  PlayerStatsTableViewCell.swift
//  BasketballTeams
//
//  Created by Ivan on 08/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit

class PlayerStatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var age: UILabel!
    
    func setup(_ player: Player, _ image: UIImage?){
        if image != nil {
            mainImage.image = image
            progressIndicator.stopAnimating()
        }
        name.text = player.name
        age.text = String.getAge(player.date ?? "")
        height.text = String.getBodyMetrics(player.height ?? "")
        weight.text = String.getBodyMetrics(player.weight ?? "")
    }
}
