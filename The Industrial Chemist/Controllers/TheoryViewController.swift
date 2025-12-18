//
//  TheoryViewController.swift
//  The Industrial Chemist
//
//  Created by user@7 on 07/11/25.
//

import UIKit

class TheoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func nextPressed(_ sender: UIButton) {
        let buildVC = BuildViewController(nibName: "Build", bundle: nil)
        self.navigationController?.pushViewController(buildVC, animated: true)
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
