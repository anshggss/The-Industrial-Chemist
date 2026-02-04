import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // 1. Capture the window scene
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // 2. Initialize the window
        let window = UIWindow(windowScene: windowScene)
        
        // 3. Set the initial root to SplashViewController.
        // This prevents the "Login Screen Flicker" because the Splash screen
        // will stay visible until the logic decides where to go next.
        window.rootViewController = SplashViewController()
        
        self.window = window
        window.makeKeyAndVisible()
    }

    /// Call this method from anywhere (Login, Logout, Onboarding) to swap the root view controller smoothly.
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        
        window.rootViewController = vc
        
        if animated {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
    }
}
