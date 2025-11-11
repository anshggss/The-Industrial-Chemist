//
//  LogInViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 06/11/25.
//

import UIKit

class LogInViewController: UIViewController {
    
    private var email = ""
    private var password = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.layer.cornerRadius = 40
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    @IBAction func forgotPasswordPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Forgot Password", bundle: nil)
        
        guard let forgotVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController else {
                print("⚠️ Could not find ForgotPasswordViewController in Forgot Password.storyboard")
                return
            }
            
            forgotVC.modalPresentationStyle = .fullScreen
            present(forgotVC, animated: false)
        
    }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        self.email = email
        self.password = password
        print("\(email), \(password)")
        let homeVC = HomeScreenViewController(nibName: "HomeScreen", bundle: nil)
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true)
        
    }
    
    
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Sign-Up", bundle: nil)
        
        guard let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
                print("⚠️ Could not find ForgotPasswordViewController in Forgot Password.storyboard")
                return
            }
            
            signUpVC.modalPresentationStyle = .fullScreen
            present(signUpVC, animated: true)
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
