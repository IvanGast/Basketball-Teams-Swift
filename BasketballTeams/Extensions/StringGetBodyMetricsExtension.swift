//
//  StringGetBodyMetricsExtension.swift
//  BasketballTeams
//
//  Created by Ivan on 18/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
extension String {
    static func getBodyMetrics(_ text: String) -> String {
        guard !text.isEmpty, let regex = try? NSRegularExpression(pattern: "(?<=\\()[^()]{1,10}(?=\\))", options: .caseInsensitive) else { return "Not available" }
        let results = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
        var data = results.map {
            String(text[Range($0.range, in: text)!])
        }
        if data.count == 0 || data[0] == "" {
            return "Not available"
        } else {
            return data[0]
        }
    }
}
