//
//  SignUpViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 06/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class SignUpViewController: UIViewController {
    
    private var user: User = User(name: "", email: "", password: "", phone: "", experience: 10)
    
    private var password: String = ""
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signInButtonPressed(_ sender: UIButton) {

        guard let name = nameTextField.text, !name.isEmpty,
              let phone = numberTextField.text, !phone.isEmpty,
              let email = mailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert("Please fill all fields")
            return
        }

        if password != confirmPassword {
            showAlert("Passwords do not match")
            return
        }

        // 🔥 Create user in Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else { return }

            // 🧠 Save extra user data in Firestore
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "name": name,
                "email": email,
                "phone": phone,
                "experience": 10
            ]) { error in
                if let error = error {
                    self.showAlert("Error saving user data: \(error.localizedDescription)")
                    return
                }

                print("✅ User created and data saved")

                // Go to main app directly (user is already logged in)
                let tabBarVC = TabBarViewController()
                tabBarVC.modalPresentationStyle = .fullScreen
                self.present(tabBarVC, animated: true)
            }
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Sign Up Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func returnToLoginPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
