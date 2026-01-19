//
//  SetUpViewController.swift
//  The Industrial Chemist
//
//  Created by user@7 on 07/11/25.
//

import UIKit

class SetUpViewController: UIViewController {
    
    @IBOutlet weak var analogyLabel: UILabel!
    
    @IBOutlet weak var setUpLabel: UILabel!
    
    let experiment: Experiment
    
    init(experiment: Experiment, nib: String) {
        self.experiment = experiment
        super.init(nibName: nib, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabel.text = experiment.Setup[0]
        analogyLabel.text = experiment.Setup[1]
        // Do any additional setup after loading the view.
    }

    @IBAction func proceedPressed(_ sender: UIButton) {
        let theoryVC = TheoryViewController(experiment: experiment)
        self.navigationController?.pushViewController(theoryVC, animated: false)
        
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
