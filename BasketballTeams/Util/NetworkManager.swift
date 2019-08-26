//
//  NetworkManager.swift
//  BasketballTeams
//
//  Created by Ivan on 26/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager: NSObject {
    var reachability: Reachability!
    public static let sharedInstance = NetworkManager()
    override init() {
        super.init()
        reachability = Reachability()!
    }

    func isReachable() -> Bool {
        return NetworkManager.sharedInstance.reachability.connection != .none
    }
}
