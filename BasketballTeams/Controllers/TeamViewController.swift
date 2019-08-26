//
//  NewPageViewController.swift
//  BasketballTeams
//
//  Created by Ivan on 08/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stadiumImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    var currentTeam: Team? {
        didSet {
            loadImage()
        }
    }
    private var stadiumImagePicture: UIImage? {
        didSet {
            if stadiumImage != nil {
                progressIndicator.stopAnimating()
                stadiumImage.image = stadiumImagePicture
            }
        }
    }
    @IBOutlet weak var segment: UISegmentedControl!
    var pageViewController: UIPageViewController!
    var playerViewController: PlayersPageViewController!
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(name: "gamesPage"),
                self.newViewController(name: "playersPage")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        if stadiumImagePicture != nil {
            progressIndicator.stopAnimating()
            stadiumImage.image = stadiumImagePicture
        }
        mainLabel.text = currentTeam?.name
        segment.superview?.clipsToBounds = true
        segment.setCustomFont()
        if let firstViewController = orderedViewControllers.first {
            (firstViewController as! GamesPageViewController).currentTeam = currentTeam
            pageViewController.setViewControllers([firstViewController],
                                                  direction: .reverse,
                                                  animated: false,
                                                  completion: nil)
        }
        setupNBANavigation()
    }
    
    private func loadImage() {
        if NetworkManager.sharedInstance.isReachable() {
            AFAPIManager.sharedInstance.loadImage(url: currentTeam?.stadiumUrl ?? "") {
                response in
                switch response {
                case .success(let image):
                    self.stadiumImagePicture = image
                case .failure(let message):
                    self.stadiumImagePicture = UIImage(named: "na") ?? UIImage()
                    self.showToast(message.localizedDescription)
                }
            }
        } else {
            stadiumImagePicture = UIImage(named: "na") ?? UIImage()
        }
    }
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIPageViewController {
            pageViewController = vc
            pageViewController.dataSource = self
            pageViewController.delegate = self
            pageViewController.setViewControllers([orderedViewControllers[0]], direction: .forward, animated: true, completion: nil)
        }
    }
 
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segment.selectedSegmentIndex = 0
            let firstViewController = orderedViewControllers[0]
            (firstViewController as! GamesPageViewController).currentTeam = currentTeam
            pageViewController.setViewControllers([firstViewController],
                               direction: .reverse,
                               animated: true,
                               completion: nil)
        case 1:
            segment.selectedSegmentIndex = 1
            let secondViewController = orderedViewControllers[1]
            (secondViewController as! PlayersPageViewController).currentTeam = currentTeam
            pageViewController.setViewControllers([secondViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        default:
            break
        }
    }
}
//MARK: PageViewController methods
extension TeamViewController {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        segment.selectedSegmentIndex = 0
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        segment.selectedSegmentIndex = 0
        let controller = orderedViewControllers[previousIndex]
        if previousIndex == 0 {
            (controller as! GamesPageViewController).currentTeam = currentTeam
        } else {
            (controller as! PlayersPageViewController).currentTeam = currentTeam
        }
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        segment.selectedSegmentIndex = 1
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        let controller = orderedViewControllers[nextIndex]
        if nextIndex == 0 {
            (controller as! GamesPageViewController).currentTeam = currentTeam
        } else {
            (controller as! PlayersPageViewController).currentTeam = currentTeam
        }
        return controller
    }
    
    func setPlayerController() {
        let firstViewController = orderedViewControllers[1] as! PlayersPageViewController
        firstViewController.currentTeam = currentTeam
        playerViewController = firstViewController
        pageViewController.setViewControllers([firstViewController],
                                              direction: .reverse,
                                              animated: false,
                                              completion: nil)
    }
}
