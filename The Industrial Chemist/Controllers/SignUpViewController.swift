//
//  SignUpViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 06/11/25.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private var user: User = User(name: "", email: "", password: "", phone: "")
    
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
        
        guard let nameTextField = self.nameTextField?.text, let numberTextField = self.numberTextField?.text, let mailTextField = self.mailTextField?.text, let passwordTextField = self.passwordTextField?.text, let confirmPasswordTextField = self.confirmPasswordTextField?.text else {
            return
        }
        
        if passwordTextField != confirmPasswordTextField {
            print("Type same password")
            return
        }
        
        user.email = mailTextField
        user.name = nameTextField
        user.phone = numberTextField
        user.password = passwordTextField
        
        
        
        
        let loginVC = LogInViewController(nibName: "LogIn", bundle: nil)
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: false)
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
