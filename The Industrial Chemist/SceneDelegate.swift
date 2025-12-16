import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        // ✅ Load XIB correctly
        let vc = HomeScreen2ViewController(nibName: "HomeScreen2", bundle: nil)

        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
