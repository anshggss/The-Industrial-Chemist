//
//  SplashViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 04/02/26.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

class SplashViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserState()
    }

    private func checkUserState() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "seenOnboarding")
        if !hasSeenOnboarding {
            showOnboarding()
            return
        }

        if let firebaseUser = Auth.auth().currentUser {
            fetchUserDataAndNavigate(uid: firebaseUser.uid)
        } else {
            showLogin()
        }
    }

    private func showOnboarding() {
        let vc = OnboardingPageViewController(transitionStyle: .scroll,
                                             navigationOrientation: .horizontal)
        replaceRoot(with: vc)
    }

    private func showLogin() {
        replaceRoot(with: Login2ViewController())
    }

    private func showMainApp() {
        replaceRoot(with: TabBarViewController())
    }

    private func replaceRoot(with vc: UIViewController) {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = scene.delegate as? SceneDelegate
        else { return }

        sceneDelegate.changeRootViewController(vc, animated: true)
    }

    private func fetchUserDataAndNavigate(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            if let data = snapshot?.data(), error == nil {
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
                self?.showLogin()
            }
        }
    }
}
