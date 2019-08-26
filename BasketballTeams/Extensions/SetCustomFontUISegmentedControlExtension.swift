//
//  SetCustomFontUISegmentedControlExtension.swift
//  BasketballTeams
//
//  Created by Ivan on 24/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit
extension UISegmentedControl {
    func setCustomFont() {
        let font = UIFont.systemFont(ofSize: 22)
        self.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
}
