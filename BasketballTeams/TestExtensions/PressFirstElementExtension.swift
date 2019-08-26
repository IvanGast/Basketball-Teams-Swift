//
//  PressFirstElementExtension.swift
//  BasketballTeams
//
//  Created by Ivan on 25/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
extension TeamViewController {
    func pressFirstElement(){
        performSegue(withIdentifier: "showTeams", sender: 0)
    }
}
