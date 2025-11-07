//
//  LogInViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 06/11/25.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var logInImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logInImageView.roundCorners(topLeft: 30, topRight: 0, bottomLeft: 30, bottomRight: 0)
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
