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

        // Do any additional setup after loading the view.
        let homeVC = HomeScreenViewController(nibName: "HomeScreen", bundle: nil)
//        let learnVC = ModuleViewController(nibName: "Modules", bundle: nil)
        let modulesStoryboard = UIStoryboard(name: "Modules", bundle: nil)
        let learnVC = modulesStoryboard.instantiateInitialViewController()!

        let leaderBoardVC = LeaderboardAllTimeViewController(nibName: "LeaderBoardAllTime", bundle: nil)
        let profileVC = ProfileViewController(nibName: "Profile", bundle: nil)
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        learnVC.tabBarItem = UITabBarItem(title: "Learn", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        leaderBoardVC.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(systemName: "trophy"), selectedImage: UIImage(systemName: "trophy.fill"))
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.viewControllers = [homeVC, learnVC, leaderBoardVC, profileVC]
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
