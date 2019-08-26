//
//  ViewController.swift
//  BasketballTeams
//
//  Created by Ivan on 04/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit

class TeamListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ReachabilityObserverDelegate {
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            showToast("Internet is not available")
        }
    }
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var leagueId: String? {
        didSet {
            getTeams()
        }
    }
    private var teamList = [Team]()
    private var imageList = [UIImage]()
    private var cellIdentifier = CellIdentifier.teamList.rawValue
    private var height = 200
    private var width = 340
    private var refreshControl: UIRefreshControl?
    private var listButton: UIBarButtonItem?
    private var gridButton: UIBarButtonItem?
    let blueColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        addReachabilityObserver()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        self.refreshControl = refreshControl
        collectionView.isHidden = true
        setupNBANavigation()
        setupNavigationButtons()
    }
    
    private func setupNavigationButtons() {
        listButton = UIBarButtonItem(image: UIImage(named: "List"), style: .plain, target: self, action: #selector(makeCollection))
        listButton?.tintColor = .red
        gridButton = UIBarButtonItem(image: UIImage(named: "Grid"), style: .plain, target: self, action: #selector(makeTable))
        self.navigationItem.setRightBarButtonItems([listButton ?? UIBarButtonItem(), gridButton ?? UIBarButtonItem()], animated: true)
    }
    
    private func getTeams() {
        RealmDatabaseManager.sharedInstance.readTeams(leagueId ?? "") { teams in
            if teams.count != 0 {
                self.teamList = teams
                self.checkForUpdate()
                self.checkBeforeLoadingImage()
            } else {
                self.updateData()
            }
        }
    }
    
    private func setTeamsNotAvailable() {
        imageList.append(UIImage(named: "na") ?? UIImage())
        teamList.append(Team("", "", "", "", "", "", ""))
        stopAnimatingIndicator()
    }
    
    private func stopAnimatingIndicator() {
        progressIndicator.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    private func checkForUpdate() {
        if NetworkManager.sharedInstance.isReachable() {
            if SavedTimeUserDefaults.shouldUpdateTeams() {
                updateData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? TeamViewController {
            controller.currentTeam = teamList[sender as! Int]
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
        for _ in 0..<teamList.count {
            imageList.append(UIImage(named: "na") ?? UIImage() )
        }
        stopAnimatingIndicator()
    }
    
    @objc func refreshTable() {
        if NetworkManager.sharedInstance.isReachable() {
            updateData()
        } else {
            showToast("Internet is not available")
        }
        guard self.teamList.count != 0 else {
            setTeamsNotAvailable()
            return
        }
        refreshControl?.endRefreshing()
    }
}
//MARK: - Navigation buttons methods
extension TeamListViewController {
    @objc func makeCollection() {
        gridButton?.tintColor = blueColor
        listButton?.tintColor = .red
        cellIdentifier = CellIdentifier.teamList.rawValue
        width = 340
        height = 200
        collectionView.reloadData()
    }
    
    @objc func makeTable() {
        listButton?.tintColor = blueColor
        gridButton?.tintColor = .red
        cellIdentifier = CellIdentifier.teamGrid.rawValue
        width = 100
        height = 110
        collectionView.reloadData()
    }
}
// MARK: - API and Realm requests
extension TeamListViewController {
    private func loadImage(_ index: Int) {
        AFAPIManager.sharedInstance.loadImage(url: teamList[index].badgeUrl ?? "", { response in
            switch response {
                case .success(let image):
                    self.imageList.append(image)
                    break
                case .failure(let message):
                    self.showToast(message.localizedDescription)
            }
            if index + 1 == self.teamList.count {
                self.stopAnimatingIndicator()
            } else {
                self.loadImage(index + 1)
            }
        })
    }
    
    private func updateData() {
        AFAPIManager.sharedInstance.getTeams(leagueId ?? "") { response in
            switch response {
            case .success(let teams):
                if teams.count != 0 {
                    self.teamList = teams
                    self.imageList.removeAll()
                    self.checkBeforeLoadingImage()
                    self.createTeams(teams)
                } else {
                    if self.teamList.count == 0 {
                        self.setTeamsNotAvailable()
                    }
                }
            case .failure(let message):
                self.showToast(message.localizedDescription)
                break
            }
        }
    }
    
    func createTeams(_ teams: [Team]){
        RealmDatabaseManager.sharedInstance.deleteTeams(leagueId ?? "")
        RealmDatabaseManager.sharedInstance.createTeams(teams)
    }
}
// MARK: - UICollectionView methods
extension TeamListViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var image = UIImage()
        if imageList.count > indexPath.row {
            image = imageList[indexPath.row]
        }
        if cellIdentifier == CellIdentifier.teamList.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TeamCollectionViewCell
            cell.setup(teamList[indexPath.row], image, CellIdentifier.teamList.rawValue + "\(indexPath.row)")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TeamGridCollectionViewCell
            cell.setup(teamList[indexPath.row].name ?? "", image, CellIdentifier.teamGrid.rawValue + "\(indexPath.row)")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellIdentifier == CellIdentifier.teamList.rawValue, teamList[indexPath.row].descriptionTeam == nil {
            return CGSize(width: width, height: 80)
        } else {
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTeams", sender: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
}

