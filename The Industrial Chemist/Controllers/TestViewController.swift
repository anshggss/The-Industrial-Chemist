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
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
