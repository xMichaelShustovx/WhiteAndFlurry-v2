//
//  MainTabBarController.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Properties and variables

    private var feedVC: FeedViewController?
    private var favouredPhotosVC: FavouredPhotosViewController?
    
    // MARK: - LifeCycle
    
    override func loadView() {
        super.loadView()
        
        // Send first data request
        NetworkManager.getPhotos()
        // Setup view
        setupViewControllers()
        setupTabBar()
    }
    
    // MARK: - Private Methods
    
    private func setupViewControllers() {
        feedVC = FeedViewController()
        favouredPhotosVC = FavouredPhotosViewController()

        feedVC?.title = "Feed"
        favouredPhotosVC?.title = "Favoured"

        tabBar.backgroundColor = .white

        setViewControllers([feedVC!, favouredPhotosVC!], animated: false)
    }
    
    private func setupTabBar() {
        guard tabBar.items?.count == 2 else {
            return
        }
        tabBar.items![0].image = UIImage(systemName: "square.grid.2x2")
        tabBar.items![1].image = UIImage(systemName: "star")
    }
}
