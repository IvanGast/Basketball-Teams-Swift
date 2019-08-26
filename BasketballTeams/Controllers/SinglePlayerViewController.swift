//
//  SinglePlayerViewController.swift
//  BasketballTeams
//
//  Created by Ivan on 08/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit
import Hero

class SinglePlayerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var image: UIImage?
    var currentPlayer: Player? {
        didSet {
            AFAPIManager.sharedInstance.loadImage(url: currentPlayer?.thumbUrl ?? "") { response in
                switch response {
                case .success(let myImage):
                    self.image = myImage
                    break
                case .failure(let message):
                    self.image = UIImage(named: "na") ?? UIImage()
                    self.showToast(message.localizedDescription)
                    break
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        self.setupNBANavigation()
    }
}

// MARK: - UITableView methods
extension SinglePlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.playerDescription.rawValue) as! PlayerDescriptionTableViewCell
        cell.setup(currentPlayer?.descriptionPlayer ?? "", "myCell\(indexPath.row)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.playerStats.rawValue) as! PlayerStatsTableViewCell
        cell.setup(currentPlayer!, image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
}
