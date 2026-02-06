import UIKit
import FirebaseAuth
import GoogleSignIn  // ADD THIS

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

        window.rootViewController = SplashViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    // Required for Google Sign-In to work
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        GIDSignIn.sharedInstance.handle(url)
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
