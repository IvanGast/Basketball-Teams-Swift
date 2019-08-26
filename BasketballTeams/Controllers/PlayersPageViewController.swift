//
//  PlayersPageViewController.swift
//  BasketballTeams
//
//  Created by Ivan on 08/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit
import Hero

class PlayersPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReachabilityObserverDelegate  {
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            showToast("Internet is not available")
        }
    }
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    private var refreshControl: UIRefreshControl?
    @IBOutlet weak var tableView: UITableView!
    private var imageList = [UIImage]()
    private var playersNotAvailable = false
    var currentTeam: Team? {
        didSet {
            if currentTeam != nil {
                getPlayers()
            }
        }
    }
    private var playersList = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func getPlayers() {
        RealmDatabaseManager.sharedInstance.readPlayers(currentTeam?.id ?? "") { players in
            if players.count != 0 {
                self.playersList = players
                self.checkBeforeLoadingImage()
                self.checkForUpdate()
            } else {
                self.refreshTable()
            }
        }
    }
    
    private func checkBeforeLoadingImage() {
        if NetworkManager.sharedInstance.isReachable() {
            loadImage(0)
        } else {
            showToast("Internet is not available")
            fillImageList()
        }
    }
    
    private func fillImageList() {
        for _ in 0..<playersList.count {
            imageList.append(UIImage(named: "na") ?? UIImage() )
        }
        stopAnimatingIndicator()
    }
    
    private func setupViews() {
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
        addReachabilityObserver()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        self.refreshControl = refreshControl
        tableView.refreshControl = refreshControl
        tableView.isHidden = true
        if playersNotAvailable {
            tableView.isUserInteractionEnabled = false
            stopAnimatingIndicator()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let singlePlayerViewController = segue.destination as? SinglePlayerViewController {
            singlePlayerViewController.currentPlayer = playersList[sender as! Int]
        }
    }
    
    private func loadImage(_ index: Int) {
        if index == 0 {
            imageList.removeAll()
        }
        AFAPIManager.sharedInstance.loadImage(url: playersList[index].cutoutUrl ?? "") { response in
            switch response {
                case .success(let image):
                    self.imageList.append(image)
                    break
                case .failure(let message):
                    self.imageList.append(UIImage(named: "na") ?? UIImage())
                    self.showToast(message.localizedDescription)
                    break
            }
            if index + 1 == self.playersList.count {
                self.stopAnimatingIndicator()
            } else {
                self.loadImage(index + 1)
            }
        }
    }
}

// MARK: - Updating methods
extension PlayersPageViewController {
    @objc func refreshTable(){
        if NetworkManager.sharedInstance.isReachable() {
            updateTable()
        } else {
            guard playersList.count != 0 else {
                setPlayersNotAvailable()
                return
            }
        }
        refreshControl?.endRefreshing()
    }
    
    private func updateTable(){
        AFAPIManager.sharedInstance.getPlayers(currentTeam?.id ?? "") { response in
            switch response {
                case .success(let players):
                    if players.count != 0 {
                        self.playersList = players
                        self.imageList.removeAll()
                        self.loadImage(0)
                        RealmDatabaseManager.sharedInstance.deletePlayers(self.currentTeam?.id ?? "")
                        RealmDatabaseManager.sharedInstance.createPlayers(players)
                    } else {
                        guard self.playersList.count != 0 else {
                            self.setPlayersNotAvailable()
                            return
                        }
                    }
                    break
                case .failure(let message):
                    guard self.playersList.count != 0 else {
                        self.setPlayersNotAvailable()
                        return
                    }
                    self.showToast(message.localizedDescription)
                    break
            }
        }
    }
    
    private func setPlayersNotAvailable() {
        imageList.removeAll()
        imageList.append(UIImage(named: "na") ?? UIImage())
        playersList.append(Player("","","","Not available","","","","","", ""))
        if progressIndicator != nil, tableView != nil {
            tableView.isUserInteractionEnabled = false
            stopAnimatingIndicator()
        } else {
            playersNotAvailable = true
        }
    }
    
    private func stopAnimatingIndicator() {
        progressIndicator.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    private func checkForUpdate() {
        if NetworkManager.sharedInstance.isReachable() {
            if SavedTimeUserDefaults.shouldUpdatePlayers() {
                updatePlayersData()
            }
        } else {
            showToast("Internet not available")
        }
    }
    
    private func updatePlayersData(){
        RealmDatabaseManager.sharedInstance.readTeams(currentTeam?.leagueId ?? "") { teams in
            self.createNewPlayers(teams)
        }
    }
    
    private func createNewPlayers(_ teams: [Team]) {
        for team in teams {
            AFAPIManager.sharedInstance.getPlayers(team.id ?? "") { response in
                switch response {
                case .success(let players):
                    if players.count != 0 {
                        if team.isEqual(self.currentTeam) {
                            self.playersList = players
                            self.imageList.removeAll()
                            self.loadImage(0)
                        }
                        RealmDatabaseManager.sharedInstance.deletePlayers(team.id ?? "")
                        RealmDatabaseManager.sharedInstance.createPlayers(players)
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
extension PlayersPageViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPlayer", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.playersList.rawValue) as! PlayerTableViewCell
        var image = UIImage()
        if imageList.count == playersList.count {
            image = imageList[indexPath.row]
        }
        cell.setup(image, playersList[indexPath.row].name ?? "", playersList[indexPath.row].position ?? "", "playerCell\(indexPath.row)")
        return cell
    }
}

