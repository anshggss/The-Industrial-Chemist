//
//  Profile2ViewController.swift
//  The Industrial Chemist
//
//  Created by user@14 on 15/12/25.
//

import UIKit

class Profile2ViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var rubyLabel: UILabel!
    @IBOutlet weak var topFinishLabel: UILabel!



    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = UserManager.shared.currentUser {
            usernameLabel.text = "\(user.name)"
        }
        
        // Do any additional setup after loading the view.
    }


    @IBAction func settingsPressed(_ sender: UIButton) {
        let vc = SettingsViewController(nibName: "Settings", bundle: nil)
        
        vc.modalPresentationStyle = .automatic
        vc.modalTransitionStyle = .coverVertical
        
        self.present(vc, animated: true, completion: nil)
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
