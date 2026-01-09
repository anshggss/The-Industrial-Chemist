//
//  HomeScreen2ViewController.swift
//  The Industrial Chemist
//
//  Created by user@14 on 12/12/25.
//

import UIKit

class HomeScreen2ViewController: UIViewController {

    @IBOutlet weak var continueLearning: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
    }

    // MARK: - Tap Gesture Setup
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(continueLearningTapped))
        continueLearning.isUserInteractionEnabled = true
        continueLearning.addGestureRecognizer(tapGesture)
    }

    // MARK: - Navigation Action
    @objc private func continueLearningTapped() {
        // Create the destination view controller from XIB
        let setUpVC = SetUpViewController(nibName: "SetUp", bundle: nil)

        // Create a UINavigationController with setUpVC as the root
        let navController = UINavigationController(rootViewController: setUpVC)
        navController.modalPresentationStyle = .fullScreen

        // Present the navigation controller
        present(navController, animated: true)
        print("pressed")
    }
}
