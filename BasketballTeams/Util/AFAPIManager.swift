//
//  AFAPIManager.swift
//  BasketballTeams
//
//  Created by Ivan on 15/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import Foundation
import Alamofire

class AFAPIManager {
    public static let sharedInstance = AFAPIManager()
    
    private init(){ }
    
    func loadImage(url: String, _ completion: @escaping (Result<UIImage, Error>) -> ()) {
        if let imageUrl = URL(string: url) {
            AF.request(imageUrl).responseData { response in
                if let data = response.data, response.error == nil {
                    if let image = UIImage(data: data) {
                        completion(.success(image))
                    } else {
                        completion(.failure(CustomError.imageLoading("Couldn't parse image")))
                    }
                } else {
                    completion(.failure(CustomError.imageLoading("Couldn't load image")))
                }
            }
        } else {
            completion(.failure(CustomError.urlNotAvailable("Link for image is not available")))
        }
    }
    
    func getLeagues(_ completion: @escaping (Result<[League], Error>) -> ()) {
        if let url = URL(string: Link.leagues) {
            let decoder = JSONDecoder()
            AF.request(url).responseJSON { response in
                if response.data != nil, let leagues = try? decoder.decode(LeagueList.self, from: response.data!) {
                    completion(.success(leagues.leagues))
                } else {
                    completion(.failure(CustomError.leaguesLoading("Couldn't load leagues")))
                }
            }
        } else {
            completion(.failure(CustomError.urlNotAvailable("Link for leagues is not available")))
        }
    }

    func getTeams(_ leagueId: String, _ completion: @escaping (Result<[Team], Error>) -> ()) {
        if let url = URL(string: Link.teams + leagueId) {
            let decoder = JSONDecoder()
            AF.request(url).responseJSON { response in
                if response.data != nil, let teams = try? decoder.decode(TeamList.self, from: response.data!) {
                    SavedTimeUserDefaults.setTeamsUpdateTime()
                    completion(.success(teams.teams))
                } else {
                    completion(.failure(CustomError.teamsLoading("Couldn't load teams")))
                }
            }
        } else {
            completion(.failure(CustomError.urlNotAvailable("Link for teams is not available")))
        }
    }
    
    func getGames(_ teamId: String, _ completion: @escaping (Result<[Game], Error>) -> ()) {
        if let url = URL(string: Link.games + teamId) {
            let decoder = JSONDecoder()
            AF.request(url).responseJSON { response in
                if response.data != nil, let games = try? decoder.decode(GameList.self, from: response.data!) {
                    SavedTimeUserDefaults.setGamesUpdateTime()
                    completion(.success(games.results))
                } else {
                    completion(.failure(CustomError.gamesLoading("Couldn't load games")))
                }
            }
        } else {
            completion(.failure(CustomError.urlNotAvailable("Link for games is not available")))

        }
    }
    
    func getPlayers(_ teamId: String, _ completion: @escaping (Result<[Player], Error>) -> ()) {
        if let url = URL(string: Link.players + teamId) {
            let decoder = JSONDecoder()
            AF.request(url).responseJSON { response in
                if response.data != nil, let players = try? decoder.decode(PlayerList.self, from: response.data!) {
                    SavedTimeUserDefaults.setPlayersUpdateTime()
                    completion(.success(players.player))
                } else {
                    completion(.failure(CustomError.playersLoading("Couldn't load players")))
                }
            }
        } else {
            completion(.failure(CustomError.urlNotAvailable("Link for players is not available")))
        }
    }
}
