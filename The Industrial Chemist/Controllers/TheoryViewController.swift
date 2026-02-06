//
//  TheoryViewController.swift
//  The Industrial Chemist
//
//  Created by user@7 on 07/11/25.
//

import UIKit

class TheoryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var theoryLabel: UILabel!
    
    @IBOutlet weak var reactionLabel: UILabel!
    var isAtHome: Bool = false
    
    let experiment: Experiment
    
    init(experiment: Experiment) {
        self.experiment = experiment
        super.init(nibName: "Theory", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = experiment.title
        theoryLabel.text = experiment.Theory
        
    
        
        if experiment.title == "Ostwald Process" {
            reactionLabel.text = "4NH3 + 8O2 -> 4HNO3 + 4H20"
            reactionLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
        } else {
            reactionLabel.text = "N2 + 3H2 -> 2NH3"
            reactionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func nextPressed(_ sender: UIButton) {
        let buildVC = BuildViewController(experiment: experiment)
        buildVC.isAtHome = isAtHome
        self.navigationController?.pushViewController(buildVC, animated: false)
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
