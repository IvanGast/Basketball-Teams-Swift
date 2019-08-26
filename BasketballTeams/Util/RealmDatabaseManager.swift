//
//  RealmDataBaseManager.swift
//  BasketballTeams
//
//  Created by Ivan on 22/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmDatabaseManager {
    public static let sharedInstance = RealmDatabaseManager()
    private let realm: Realm?
    private init(){
        realm = try! Realm()
    }
    
    func deleteLeagues() {
        if let teams = realm?.objects(League.self) {
            try! realm?.write {
                realm?.delete(teams)
            }
        }
    }
    
    func deleteTeams(_ leagueId: String) {
        if let teams = realm?.objects(Team.self).filter("leagueId = '\(leagueId)'") {
            try! realm?.write {
                realm?.delete(teams)
            }
        }
    }
    
    func deletePlayers() {
        if let players = realm?.objects(Player.self) {
            try? realm?.write {
                realm?.delete(players)
            }
        }
    }
    
    func deletePlayers(_ teamId: String) {
        if let players = realm?.objects(Player.self).filter("teamId = '\(teamId)'") {
            try? realm?.write {
                realm?.delete(players)
            }
        }
    }
    
    func deleteGames(_ teamId: String, _ games: [Game]) {
        for game in games {
            let string = game.id ?? "" + teamId
            if let result = realm?.objects(Game.self).filter("id = '\(string)'") {
                try! realm?.write {
                    realm?.delete(result)
                }
            }
        }
    }
    
    func createLeagues(_ leagues: [League]) {
        try! realm?.write {
            realm?.add(leagues)
        }
    }
    
    func createTeams(_ teams: [Team]) {
        try! realm?.write {
            realm?.add(teams)
        }
    }
    
    func createPlayers(_ players: [Player]) {
        try! realm?.write {
            realm?.add(players)
        }
    }
    
    func createGames(_ teamId: String, _ games: [Game]) {
        try! realm?.write {
                realm?.add(games)
        }
    }
    
    func readLeagues(_ completion: @escaping ([League]) -> ()) {
        if let result = realm?.objects(League.self) {
            completion(Array(result))
        }
    }
    
    func readTeams(_ leagueId: String, _ completion: @escaping ([Team]) -> ()) {
        if let result = realm?.objects(Team.self).filter("leagueId = '\(leagueId)'") {
            completion(Array(result))
        }
    }
    
    func readPlayers(_ teamId: String, _ completion: @escaping ([Player]) -> ()) {
        if let result = realm?.objects(Player.self).filter("teamId = '\(teamId)'") {
            completion(Array(result))
        }
    }
    
    func readGames(_ teamId: String, _ completion: @escaping ([Game]) -> ()) {
        if let result = realm?.objects(Game.self).filter("teamId == '\(teamId)'") {
            completion(Array(result))
        }
    }
}
