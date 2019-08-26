//
//  StringGetAgeExtension.swift
//  BasketballTeams
//
//  Created by Ivan on 18/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
extension String {
    static func getAge(_ data: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        let date = Date()
        let calendar = Calendar.current
        let birthday = dateFormatter.date(from: data)
        let ageComp = calendar.dateComponents([.year], from: birthday ?? Date(), to: date)
        return String(ageComp.year!)
    }
}
