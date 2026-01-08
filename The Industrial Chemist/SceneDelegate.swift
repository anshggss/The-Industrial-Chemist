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

        // Choose initial ViewController
        let vc = OnboardingPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )

        // Alternative options (uncomment if needed)
        // let vc = SetUpViewController(nibName: "SetUp", bundle: nil)
        // let vc = TestViewController(nibName: "Test", bundle: nil)
        // let vc = ModuleViewController(nibName: "Modules", bundle: nil)

        window.rootViewController = vc
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is released by the system
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart any tasks paused while inactive
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Pause ongoing tasks
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Undo changes made when entering background
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save data and release shared resources
    }
}
