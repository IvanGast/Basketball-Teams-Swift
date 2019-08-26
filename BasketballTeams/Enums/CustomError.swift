//
//  CustomError.swift
//  BasketballTeams
//
//  Created by Ivan on 26/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
enum CustomError: Error {
    case urlNotAvailable(String)
    case imageLoading(String)
    case leaguesLoading(String)
    case teamsLoading(String)
    case gamesLoading(String)
    case playersLoading(String)
}
