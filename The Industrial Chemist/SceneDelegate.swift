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

        // Check onboarding status
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "seenOnboarding")

        let rootViewController: UIViewController

//        if hasSeenOnboarding {
//            // Go directly to Login
//            rootViewController = LogInViewController(
//                nibName: "LogIn",
//                bundle: nil
//            )
//        } else {
            // Show onboarding flow
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
