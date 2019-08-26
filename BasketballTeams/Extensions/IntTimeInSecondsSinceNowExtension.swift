//
//  IntTimeInSecondsSinceNowExtension.swift
//  BasketballTeams
//
//  Created by Ivan on 18/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
extension Int {
    static func timeInSecondsSinceNow(_ string: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date =  formatter.date(from: string)
        return Int(Date().timeIntervalSince(date ?? Date()))
    }
}
