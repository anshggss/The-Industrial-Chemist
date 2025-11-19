//
//  LeaderboardAllTimeViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 10/11/25.
//

import UIKit

class LeaderboardAllTimeViewController: UIViewController {

    @IBOutlet weak var leaderboardSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                // All-time selected → stay on this VC
                print("All-Time Leaderboard")
            case 1:
                // Weekly selected → navigate to WeeklyLeaderboardVC
                navigateToWeeklyLeaderboard()
            default:
                break
            }
    }
    func navigateToWeeklyLeaderboard() {
        print("Change page")
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
