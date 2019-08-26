//
//  StringGetCurrentTimeExtension.swift
//  BasketballTeams
//
//  Created by Ivan on 18/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
extension String {
    static func getCurrentTime () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}
