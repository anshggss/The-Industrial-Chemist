//
//  ChangePasswordViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 07/11/25.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    private var newPassword: String = ""
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard let newPassword = newPasswordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            return
        }
        
        if newPassword != confirmPassword {
            print("Type same password")
            return
        }
        self.newPassword = newPassword
        print(self.newPassword)
        
        
        
        let logIn = LogInViewController(nibName: "LogIn", bundle: nil)
        logIn.modalPresentationStyle = .fullScreen
        self.present(logIn, animated: false, completion: nil)
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
