//
//  ForgotPasswordViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 06/11/25.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    private let testingOTP = "123456"
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBOutlet weak var sendOtpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func sendOtpTapped(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.systemBlue
        sender.setTitle("OTP Sent", for: .normal)
        sender.isEnabled = false
    }

    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let otp = otpTextField.text else {
            return
        }
        if otp == testingOTP {
            print("Correct OTP")
        }
        else {
            print("OTP Incorrect")
        }
        
        
        
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
