//
//  OnboardingOneViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 10/11/25.
//

import UIKit

class OnboardingOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func continueButtonPressed(_ sender: UIButton) {
        let onboardingTwo = OnboardingTwoViewController(nibName: "OnboardingTwo", bundle: nil)
        onboardingTwo.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
            transition.duration = 0.35
            transition.type = .push
            transition.subtype = .fromRight  // 👈 changes direction to right-to-left or left-to-right
            view.window?.layer.add(transition, forKey: kCATransition)

        present(onboardingTwo, animated: true)
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
