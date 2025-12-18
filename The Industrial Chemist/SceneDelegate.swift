
//
//  SceneDelegate.swift
//  The Industrial Chemist
//
//  Created by admin25 on 05/11/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
            // Loading storyboard file
//        let vc = OnboardingOneViewController(nibName: "OnboardingOne", bundle: nil)
//
//            window.rootViewController = vc
//        let vc = OnboardingPageViewController(
//            transitionStyle: .scroll,
//            navigationOrientation: .horizontal,
//            options: nil
//        )
//        let vc = ParentRenderViewController(nibName: "Parent", bundle: nil)
        let vc = SetUpViewController(nibName: "SetUp", bundle: nil)
        window.rootViewController = vc
            self.window = window
            window.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
        // ✅ Load XIB correctly
        let vc = HomeScreen2ViewController(nibName: "HomeScreen2", bundle: nil)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
