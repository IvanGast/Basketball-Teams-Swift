//
//  GamesPageViewController.swift
//  BasketballTeams
//
//  Created by Ivan on 08/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit

class GamesPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReachabilityObserverDelegate  {
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            showToast("Internet is not available")
        }
    }
    
    private var refreshControl: UIRefreshControl?
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gamesTableView: UITableView!
    var currentTeam: Team? {
        didSet {
            if currentTeam != nil {
                getGames()
            }
        }
    }
    private var gamesList = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        addReachabilityObserver()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        self.refreshControl = refreshControl
        gamesTableView?.refreshControl = refreshControl
        gamesTableView.isHidden = true
    }
    
    private func getGames() {
        RealmDatabaseManager.sharedInstance.readGames(currentTeam?.id ?? "") { games in
            if games.count != 0 {
                self.checkForUpdate()
                self.gamesList = games
                self.progressIndicator.stopAnimating()
                self.gamesTableView.isHidden = false
                self.gamesTableView.reloadData()
            } else {
                self.refreshTable()
            }
        }
    }
}
// MARK: - Updating methods
extension GamesPageViewController {
    @objc func refreshTable() {
        if NetworkManager.sharedInstance.isReachable() {
            updateTable()
            refreshControl?.endRefreshing()
        } else {
            guard self.gamesList.count != 0 else {
                self.setGamesNotAvailable()
                return
            }
        }
        refreshControl?.endRefreshing()
    }
    
    private func updateTable() {
        AFAPIManager.sharedInstance.getGames(currentTeam?.id ?? "") { response in
            switch response {
                case .success(let games):
                    if games.count != 0 {
                        RealmDatabaseManager.sharedInstance.deleteGames(self.currentTeam?.id ?? "", games)
                        self.gamesList = games
                        self.progressIndicator.stopAnimating()
                        self.gamesTableView.isHidden = false
                        self.gamesTableView.reloadData()
                        RealmDatabaseManager.sharedInstance.createGames(self.currentTeam?.id ?? "", games)
                    } else {
                        guard self.gamesList.count != 0 else {
                            self.setGamesNotAvailable()
                            return
                        }
                    }
                    break
                case .failure(let message):
                    guard self.gamesList.count != 0 else {
                        self.setGamesNotAvailable()
                        return
                    }
                    self.showToast(message.localizedDescription)
            }
        }
    }
    
    private func setGamesNotAvailable() {
        gamesList.append(Game("","", "Not available","",""))
        progressIndicator.stopAnimating()
        gamesTableView.isHidden = false
        gamesTableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    private func checkForUpdate() {
        if NetworkManager.sharedInstance.isReachable(), SavedTimeUserDefaults.shouldUpdateGames() {
            updateData()
        }
    }
    
    private func updateData() {
        RealmDatabaseManager.sharedInstance.readTeams(currentTeam?.leagueId ?? "") { teams in
            self.createNewGames(teams)
        }
    }
    
    private func createNewGames(_ teams: [Team]) {
        for team in teams {
            AFAPIManager.sharedInstance.getGames(team.id ?? "") { response in
                switch response {
                    case .success(let games):
                        RealmDatabaseManager.sharedInstance.deleteGames(team.id ?? "", games)
                        if games.count != 0 {
                            RealmDatabaseManager.sharedInstance.createGames(team.id ?? "", games)
                        }
                        break
                    case .failure(let message):
                        self.showToast(message.localizedDescription)
                        break
                }
            }
        }
    }
}
// MARK: UITableView methods
extension GamesPageViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.gamesList.rawValue) as! GamesTableViewCell
        var string = ""
        if gamesList[indexPath.row].oponent == currentTeam?.name {
            string = gamesList[indexPath.row].home ?? ""
        } else {
            string = gamesList[indexPath.row].oponent ?? ""
        }
        cell.setup(currentTeam?.name ?? "", gamesList[indexPath.row].date ?? "", string, "newsCell\(indexPath.row)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gamesTableView.deselectRow(at: indexPath, animated: false)
    }
}
