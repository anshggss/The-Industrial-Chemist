//
//  HomeScreen2ViewController.swift
//  The Industrial Chemist
//
//  Created by user@14 on 12/12/25.
//

import UIKit

class HomeScreen2ViewController: UIViewController {

    @IBOutlet weak var continueLearning: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
    }
    
    let experiment = Experiment(
        title: "Ammonia Process",
        testExperiment: "Ammonia",
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
            "This experiment demonstrates how pressure, temperature, and catalysts are applied in industrial chemistry to produce ammonia, a key compound used in fertilizers and agriculture.",
        model: "ammonia"
    )


    
    

    // MARK: - Tap Gesture Setup
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(continueLearningTapped))
        continueLearning.isUserInteractionEnabled = true
        continueLearning.addGestureRecognizer(tapGesture)
    }

    // MARK: - Navigation Action
    @objc private func continueLearningTapped() {
        // Create the destination view controller from XIB
        let setUpVC = SetUpViewController(experiment: experiment, nib: "SetUp")

        // Create a UINavigationController with setUpVC as the root
        let navController = UINavigationController(rootViewController: setUpVC)
        navController.modalPresentationStyle = .fullScreen

        // Present the navigation controller
        present(navController, animated: true)
        print("pressed")
    }
}
