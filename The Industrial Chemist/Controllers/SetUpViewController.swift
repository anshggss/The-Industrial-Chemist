//
//  SetUpViewController.swift
//  The Industrial Chemist
//
//  Created by user@7 on 07/11/25.
//

import UIKit

class SetUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func proceedPressed(_ sender: UIButton) {
        let theoryVC = TheoryViewController(nibName: "Theory", bundle: nil)
        self.navigationController?.pushViewController(theoryVC, animated: true)
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
