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

        let storyboard = UIStoryboard(name: "Modules", bundle: nil)

        let modulesVC = storyboard.instantiateViewController(
            withIdentifier: "ModulesVC"
        )

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = modulesVC
        self.window = window
        window.makeKeyAndVisible()
    }
}

//
//import UIKit
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene,
//               willConnectTo session: UISceneSession,
//               options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        // Initialize a new window with the provided windowScene
//        let window = UIWindow(windowScene: windowScene)
//
//        // Choose your initial view controller
//        let vc = ModuleViewController(nibName: "Modules", bundle: nil)
//        window.rootViewController = vc
//
//        // Assign to the SceneDelegate's window property and make visible
//        self.window = window
//        window.makeKeyAndVisible()
//    }
//
//    func sceneDidDisconnect(_ scene: UIScene) {
//        // Called as the scene is being released by the system.
//        // This occurs shortly after the scene enters the background, or when its session is discarded.
//        // Release any resources associated with this scene that can be re-created the next time the scene connects.
//        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
//    }
//}
