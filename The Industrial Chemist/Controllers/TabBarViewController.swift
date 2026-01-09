//
//  TabBarViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 19/11/25.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarAppearance()
        setupViewControllers()
    }

    // MARK: - Tab Bar Appearance
    private func setupTabBarAppearance() {

        let tabBarBackgroundColor = UIColor(
            red: 26.0 / 255.0,
            green: 1.0 / 255.0,
            blue: 41.0 / 255.0,
            alpha: 1.0
        )

        let lightPurple = UIColor(
            red: 0.74,
            green: 0.58,
            blue: 0.98,
            alpha: 1.0
        )

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = tabBarBackgroundColor

            appearance.stackedLayoutAppearance.selected.iconColor = lightPurple
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: lightPurple
            ]

            appearance.stackedLayoutAppearance.normal.iconColor = lightPurple.withAlphaComponent(0.6)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: lightPurple.withAlphaComponent(0.6)
            ]

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = tabBarBackgroundColor
            tabBar.isTranslucent = false
            tabBar.tintColor = lightPurple
            tabBar.unselectedItemTintColor = lightPurple.withAlphaComponent(0.6)
        }
    }

    // MARK: - View Controllers
    private func setupViewControllers() {

        let homeVC = HomeScreen2ViewController(nibName: "HomeScreen2", bundle: nil)

        let modulesStoryboard = UIStoryboard(name: "Modules", bundle: nil)
        let learnVC = modulesStoryboard.instantiateInitialViewController()!

        let leaderBoardVC = Leaderboard2ViewController(nibName: "Leaderboard2", bundle: nil)
        let profileVC = Profile2ViewController(nibName: "Profile2", bundle: nil)

        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        learnVC.tabBarItem = UITabBarItem(
            title: "Learn",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )

        leaderBoardVC.tabBarItem = UITabBarItem(
            title: "Leaderboard",
            image: UIImage(systemName: "trophy"),
            selectedImage: UIImage(systemName: "trophy.fill")
        )

        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [
            homeVC,
            learnVC,
            leaderBoardVC,
            profileVC
        ]
    }
}
