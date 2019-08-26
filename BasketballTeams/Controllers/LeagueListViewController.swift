//
//  ViewController.swift
//  BasketballTeams
//
//  Created by Ivan on 23/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit

class LeagueListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ReachabilityObserverDelegate {
    
    func reachabilityChanged(_ isReachable: Bool) {
        isInternetAvailable = isReachable
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var isInternetAvailable: Bool?
    private var listButton: UIBarButtonItem?
    private var gridButton: UIBarButtonItem?
    private var cellIdentifier = CellIdentifier.leagueList.rawValue
    private var height = 90
    private var width = 340
    private let blueColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    private var leaguesList: [League]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    private func setupViews() {
        addReachabilityObserver()
//        collectionView.isHidden = true
//        let transform = CGAffineTransform(scaleX: 2, y: 2)
//        progressIndicator.transform = transform
        setupLeagueNavigation()
        setupNavigationButtons()
        getLeagues()
    }
    
    private func getLeagues() {
        RealmDatabaseManager.sharedInstance.readLeagues() { leagues in
            if leagues.count != 0 {
                self.leaguesList = leagues
            } else {
                self.loadLeagues()
            }
        }
    }
    
    private func loadLeagues() {
        if NetworkManager.sharedInstance.isReachable() {
            AFAPIManager.sharedInstance.getLeagues { response in
                switch response {
                    case .success(let leagues):
                        self.leaguesList = leagues
                        RealmDatabaseManager.sharedInstance.deleteLeagues()
                        RealmDatabaseManager.sharedInstance.createLeagues(leagues)
                        break
                    case .failure(let message):
                        self.showToast(message.localizedDescription)
                        break
                }
            }
        } else {
            showToast("No internet available")
        }
    }
    
    private func setupNavigationButtons() {
        listButton = UIBarButtonItem(image: UIImage(named: "List"), style: .plain, target: self, action: #selector(makeCollection))
        listButton?.tintColor = .red
        gridButton = UIBarButtonItem(image: UIImage(named: "Grid"), style: .plain, target: self, action: #selector(makeTable))
        self.navigationItem.setRightBarButtonItems([listButton!, gridButton!], animated: true)
    }
    
    @objc func makeCollection() {
        gridButton?.tintColor = blueColor
        listButton?.tintColor = .red
        cellIdentifier = CellIdentifier.leagueList.rawValue
        width = 340
        height = 90
        collectionView.reloadData()
    }
    
    @objc func makeTable() {
        listButton?.tintColor = blueColor
        gridButton?.tintColor = .red
        cellIdentifier = CellIdentifier.leagueGrid.rawValue
        width = 180
        height = 190
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? TeamListViewController {
            controller.leagueId = leaguesList?[sender as! Int].id
        }
    }
}

// MARK: - UICollectionView methods
extension LeagueListViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leaguesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = UIImage()
        if cellIdentifier == CellIdentifier.leagueList.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LeagueListCollectionViewCell
            cell.setup(image, leaguesList?[indexPath.row].league ?? "")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LeagueGridCollectionViewCell
            cell.setup(image, leaguesList?[indexPath.row].league ?? "")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showLeague", sender: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
}
