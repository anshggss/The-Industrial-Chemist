import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

         
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "seenOnboarding")

        let rootViewController: UIViewController

//        if hasSeenOnboarding {
//            // Go directly to Login
//            rootViewController = Login2ViewController()
//        } else {
             
            rootViewController = OnboardingPageViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal,
                options: nil
            )
//        }

        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}

//import UIKit
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(
//        _ scene: UIScene,
//        willConnectTo session: UISceneSession,
//        options connectionOptions: UIScene.ConnectionOptions
//    ) {
//
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        let loginVC = Login2ViewController()
//
//        window.rootViewController = loginVC
//        self.window = window
//        window.makeKeyAndVisible()
//    }
//}

