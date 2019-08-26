//
//  BasketballTeamsTests.swift
//  BasketballTeamsTests
//
//  Created by Ivan on 09/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import XCTest
@testable import BasketballTeams

class BasketballTeamsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLeaguesLoadedAPI() {
        AFAPIManager.sharedInstance.getLeagues { response in
            switch response {
            case .success(let leagues):
                XCTAssertTrue(leagues.count > 0)
                break
            case .failure(_):
                XCTFail()
                break
            }
        }
    }
    
    func testTeamsLoadedAPI() {
        AFAPIManager.sharedInstance.getLeagues { response in
            switch response {
            case .success(let leagues):
                for league in leagues {
                    AFAPIManager.sharedInstance.getTeams(league.id ?? ""){ response in
                        switch response {
                            case .success(let teams):
                                XCTAssertTrue(teams.count > 0)
                                break
                            case .failure(_):
                                XCTFail()
                                break
                        }
                    }
                }
                break
            case .failure(_):
                XCTFail()
                break
            }
        }
    }
    
    func testGamesLoadedFromAPI() {
        AFAPIManager.sharedInstance.getLeagues { response in
            switch response {
                case .success(let leagues):
                    for league in leagues {
                        AFAPIManager.sharedInstance.getTeams(league.id ?? ""){ response in
                            switch response {
                                case .success(let teams):
                                    for team in teams {
                                        AFAPIManager.sharedInstance.getGames(team.id ?? "") { response in
                                            switch response {
                                            case .success(let games):
                                                XCTAssertTrue(games.count > 0)
                                                break
                                            case .failure(_):
                                                XCTFail()
                                                break
                                            }
                                        }
                                    }
                                    break
                                case .failure(_):
                                    XCTFail()
                                    break
                            }
                        }
                    }
                    break
            case .failure(_):
                XCTFail()
                break
            }
        }
    }
    
    func testPlayersLoadedFromAPI() {
        AFAPIManager.sharedInstance.getLeagues { response in
            switch response {
            case .success(let leagues):
                for league in leagues {
                    AFAPIManager.sharedInstance.getTeams(league.id ?? ""){ response in
                        switch response {
                        case .success(let teams):
                            for team in teams {
                                AFAPIManager.sharedInstance.getPlayers(team.id ?? "") { response in
                                    switch response {
                                    case .success(let players):
                                        XCTAssertTrue(players.count > 0)
                                        break
                                    case .failure(_):
                                        XCTFail()
                                        break
                                    }
                                }
                            }
                            break
                        case .failure(_):
                            XCTFail()
                            break
                        }
                    }
                }
                break
            case .failure(_):
                XCTFail()
                break
            }
        }
    }

    func testImageIsLoadedFromAPI() {
        AFAPIManager.sharedInstance.loadImage(url: "https://www.thesportsdb.com/images/media/team/badge/cfcn1w1503741986.png", { response in
            switch response {
            case .success(let image):
                XCTAssertNotNil(image)
                break
            case .failure(_):
                XCTFail()
                break
            }
        })
    }
    
    func testUserDefaults() {
        SavedTimeUserDefaults.setTeamsUpdateTime()
        XCTAssertFalse(SavedTimeUserDefaults.shouldUpdateTeams())
        UserDefaults.standard.set("2019.05.05 11:12:12", forKey: "Team")
        XCTAssertTrue(SavedTimeUserDefaults.shouldUpdateTeams())
    }
    
    func testReadLeaguesRealm() {
        
    }
    
    func testDeleteCreateReadTeamsRealm() {
        AFAPIManager.sharedInstance.getLeagues { response in
            switch response {
            case .success(let leagues):
                for league in leagues {
                    RealmDatabaseManager.sharedInstance.deleteTeams(league.id ?? "")
                    AFAPIManager.sharedInstance.getTeams(league.id ?? "") { response in
                        switch response {
                        case .success(let teams):
                            RealmDatabaseManager.sharedInstance.createTeams(teams)
                            RealmDatabaseManager.sharedInstance.readTeams(league.id ?? "") { teams in
                                XCTAssertNotNil(teams)
                            }
                            break
                        case .failure(_):
                            XCTFail()
                            break
                        }
                    }
                }
                break
            case .failure(_):
                XCTFail()
                break
            }
        }
        
    }
    
    func testDeleteCreateReadGamesRealm() {
        RealmDatabaseManager.sharedInstance.readLeagues { leagues in
            for league in leagues {
                RealmDatabaseManager.sharedInstance.readTeams(league.id ?? "") { teams in
                    for team in teams {
                        RealmDatabaseManager.sharedInstance.readGames(team.id ?? "") { games in
                            RealmDatabaseManager.sharedInstance.deleteGames(team.id ?? "", games)
                            AFAPIManager.sharedInstance.getGames(team.id ?? "") { response in
                                switch response {
                                case .success(let games):
                                    RealmDatabaseManager.sharedInstance.createGames(team.id ?? "", games)
                                    RealmDatabaseManager.sharedInstance.readGames(team.id ?? "") { games in
                                        XCTAssertNotNil(games)
                                    }
                                    break
                                case .failure(_):
                                    XCTFail()
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tesDeleteCreateReadPlayersRealm() {
        RealmDatabaseManager.sharedInstance.readLeagues { leagues in
            for league in leagues {
                RealmDatabaseManager.sharedInstance.readTeams(league.id ?? "") { teams in
                    for team in teams {
                        RealmDatabaseManager.sharedInstance.deletePlayers(team.id ?? "")
                        AFAPIManager.sharedInstance.getPlayers(team.id ?? "") { response in
                            switch response {
                            case .success(let players):
                                RealmDatabaseManager.sharedInstance.createPlayers(players)
                                RealmDatabaseManager.sharedInstance.readPlayers(team.id ?? "") { players in
                                    XCTAssertNotNil(players)
                                }
                                break
                            case .failure(_):
                                XCTFail()
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
