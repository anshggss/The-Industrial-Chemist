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
    
    let ammoniaExperiment = Experiment(
        
        Setup: [
            // Label: Setup Your Workspace
            "Ensure the workspace is clean, well-ventilated, and safe before starting. Wear protective gear like gloves and safety goggles, and check all equipment, as ammonia preparation involves high pressure and temperature.",
            
            // Label: Real World Analogy
            "The process is similar to using a pressure cooker. Increased pressure and controlled heat allow nitrogen and hydrogen to react efficiently in the presence of a catalyst to form ammonia."
        ],
        
        Build: [
            // Components used in industrial preparation
            "The process uses components such as high-pressure reactors, compressors to raise gas pressure, heat exchangers for temperature control, and distillation columns to separate the formed ammonia."
        ],
        
        Theory:
            // Label: Haber Bosch Reaction
            "The Haber–Bosch process synthesizes ammonia by reacting nitrogen and hydrogen at high pressure and moderate temperature using an iron-based catalyst to speed up the reaction.",
        
        Test:
            // Haber Bosch equation
            "The Haber–Bosch reaction is represented as: N₂ + 3H₂ ⇌ 2NH₃, showing the reversible nature of the process and the role of equilibrium in ammonia production.",
        
        Results:
            // Learning Summary → Key Takeaways
            "This experiment demonstrates how pressure, temperature, and catalysts are applied in industrial chemistry to produce ammonia, a key compound used in fertilizers and agriculture."
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabel.text = ammoniaExperiment.Setup[0]
        analogyLabel.text = ammoniaExperiment.Setup[1]
        // Do any additional setup after loading the view.
    }

    @IBAction func proceedPressed(_ sender: UIButton) {
        let theoryVC = TheoryViewController(nibName: "Theory", bundle: nil)
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
