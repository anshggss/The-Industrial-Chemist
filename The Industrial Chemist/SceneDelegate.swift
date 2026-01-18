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

        // ✅ Load from XIB
        let vc = SettingsViewController(nibName: "Settings", bundle: nil)

        window.rootViewController = vc
        self.window = window
        window.makeKeyAndVisible()
    }
}
