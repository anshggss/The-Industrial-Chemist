import UIKit
import FirebaseAuth
import FirebaseFirestore

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 48/255, green: 16/255, blue: 72/255, alpha: 1) // Your theme color
        checkUserState()
    }
    
    private func checkUserState() {
        // 1. Check Onboarding
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "seenOnboarding")
        if !hasSeenOnboarding {
            showOnboarding()
            return
        }
        
        // 2. Check Firebase Auth
        if let firebaseUser = Auth.auth().currentUser {
            fetchUserDataAndNavigate(uid: firebaseUser.uid)
        } else {
            showLogin()
        }
    }
    
    private func fetchUserDataAndNavigate(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            if let data = snapshot?.data(), error == nil {
                // Populate your Global Manager
                let user = AppUser(
                    uid: uid,
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    phone: data["phone"] as? String ?? "",
                    experience: data["experience"] as? Int ?? 0
                )
                UserManager.shared.currentUser = user
                self?.showMainApp()
            } else {
                // If data fetch fails, safer to re-login
                self?.showLogin()
            }
        }
    }
    
    // MARK: - Navigation Helpers
    private func showOnboarding() {
        let vc = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        replaceRoot(with: vc)
    }
    
    private func showLogin() {
        replaceRoot(with: Login2ViewController())
    }
    
    private func showMainApp() {
        replaceRoot(with: TabBarViewController())
    }
    
    private func replaceRoot(with vc: UIViewController) {
        guard let window = view.window else { return }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}