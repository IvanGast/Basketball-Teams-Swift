//
//  SetNBANavigationLogoExtension.swift
//  BasketballTeams
//
//  Created by Ivan on 24/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit
extension UIViewController {
    func setupNBANavigation() {
        let logo = UIImage(named: "NBA")
        let image = UIImageView(image: logo)
        image.contentMode = .scaleAspectFit
        image.widthAnchor.constraint(equalToConstant: 120).isActive = true
        navigationItem.titleView = image
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
