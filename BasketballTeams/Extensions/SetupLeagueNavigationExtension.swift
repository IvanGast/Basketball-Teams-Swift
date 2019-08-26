//
//  SetupLeagueNavigationExtension.swift
//  BasketballTeams
//
//  Created by Ivan on 24/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit
extension UIViewController {
    func setupLeagueNavigation() {
        let logo = UIImage(named: "League")
        let image = UIImageView(image: logo)
        image.contentMode = .scaleAspectFit
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.navigationItem.titleView = image
    }
}
