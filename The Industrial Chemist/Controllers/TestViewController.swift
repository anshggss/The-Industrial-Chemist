//
//  TestViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 10/11/25.
//

import UIKit
import RealityKit

class TestViewController: UIViewController {

    @IBOutlet var arView: ARView!
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
            "N₂ + 3H₂ ⇌ 2NH₃",
        
        Results:
            // Learning Summary → Key Takeaways
            "This experiment demonstrates how pressure, temperature, and catalysts are applied in industrial chemistry to produce ammonia, a key compound used in fertilizers and agriculture."
    )

    @IBOutlet weak var equationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        equationLabel.text = ammoniaExperiment.Test
        
        let boxSize: CGFloat = 300
                let boxFrame = CGRect(
                    x: (view.bounds.width - boxSize) / 2,
                    y: (view.bounds.height - boxSize) / 2,
                    width: boxSize,
                    height: boxSize
                )
                
                // Create ARView in non-AR mode
//                arView = ARView(frame: boxFrame, cameraMode: .nonAR, automaticallyConfigureSession: false)
                arView.layer.cornerRadius = 15
                arView.clipsToBounds = true
                arView.backgroundColor = .systemBackground
                
                loadModel()
        
        
    }
    
    func loadModel() {
            do {
                // Load model entity
                let entity = try Entity.load(named: "model")
                entity.setScale([0.1, 0.1, 0.1], relativeTo: nil)
                entity.position = [0, 0, 0]
                
                // Wrap inside a parent ModelEntity
                let parentEntity = ModelEntity()
                parentEntity.addChild(entity)
                
                // Generate collisions for gestures
                parentEntity.generateCollisionShapes(recursive: true)
                
                // Add to an anchor
                let anchor = AnchorEntity(world: [0, 0, 0])
                anchor.addChild(parentEntity)
                arView.scene.addAnchor(anchor)
                
                // Add gestures
                arView.installGestures([.rotation, .translation, .scale], for: parentEntity)
                
                // Optional: improve lighting
                arView.environment.background = .color(.white)
                arView.environment.lighting.intensityExponent = 1.0
                arView.renderOptions.insert(.disableMotionBlur)
                arView.renderOptions.insert(.disableDepthOfField)
                
            } catch {
                print("❌ Failed to load model: \(error)")
            }
        }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let resultsVC = ResultsViewController(nibName: "Results", bundle: nil)
        self.navigationController?.pushViewController(resultsVC, animated: false)
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
