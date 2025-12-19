//
//  SceneDelegate.swift
//  The Industrial Chemist
//
//  Created by admin25 on 05/11/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = scene as? UIWindowScene else { return }

        // Create window
        let window = UIWindow(windowScene: windowScene)

        // Load XIB-based ViewController
//        let vc = SetUpViewController(nibName: "SetUp", bundle: nil)
        let vc = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        let vc = TestViewController(nibName: "Test", bundle: nil)
        window.rootViewController = vc

        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is released by the system
    }
}
