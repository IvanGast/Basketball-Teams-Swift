//
//  SaveTimeUserDefaults.swift
//  BasketballTeams
//
//  Created by Ivan on 20/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
open class SavedTimeUserDefaults: UserDefaults {
    
    static func setTeamsUpdateTime() {
        setCurrentTime(forKey: "Team")
    }
    
    static func setGamesUpdateTime() {
        setCurrentTime(forKey: "Game")
    }
    
    static func setPlayersUpdateTime() {
        setCurrentTime(forKey: "Player")
    }
    
    static func setCurrentTime(forKey key:String){
        UserDefaults.standard.set(String.getCurrentTime(), forKey: key)
    }
    
    static func shouldUpdatePlayers() -> Bool {
        return Int.timeInSecondsSinceNow(UserDefaults.standard.string(forKey: "Player") ?? "") >= UpdateTime.Player.rawValue
    }
    
    static func shouldUpdateGames() -> Bool {
        return Int.timeInSecondsSinceNow(UserDefaults.standard.string(forKey: "Game") ?? "") >= UpdateTime.Game.rawValue
    }
    
    static func shouldUpdateTeams() -> Bool {
        return Int.timeInSecondsSinceNow(UserDefaults.standard.string(forKey: "Team") ?? "") >= UpdateTime.Team.rawValue
    }
}
