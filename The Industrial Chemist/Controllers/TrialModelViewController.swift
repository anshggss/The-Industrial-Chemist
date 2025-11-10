//
//  TrialModelViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 10/11/25.
//

import UIKit
import SceneKit
import RealityKit
import Computer

class TrialModelViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARView(frame: view.bounds, cameraMode: .nonAR, automaticallyConfigureSession: false)

        view.addSubview(arView)
        loadModel()
        // Do any additional setup after loading the view.
        
        
    }
    
    func loadModel() {
            do {
                // Load model as a generic Entity
                let entity = try Entity.load(named: "computer")
                entity.setScale([0.1, 0.1, 0.1], relativeTo: nil)
                entity.position = [0, 0, 0]
                
                // ✅ Wrap in a ModelEntity-like parent so we can attach gestures
                let parentEntity = ModelEntity()
                parentEntity.addChild(entity)
                
                // ✅ Now generate collision on the parent
                parentEntity.generateCollisionShapes(recursive: true)

                // Create anchor
                let anchor = AnchorEntity(world: [0, 0, 0])
                anchor.addChild(parentEntity)
                arView.scene.addAnchor(anchor)

                // ✅ Gestures now work (no casting)
                arView.installGestures([.rotation, .translation, .scale], for: parentEntity)

                // Optional: lighting
                arView.environment.lighting.intensityExponent = 1.0
                arView.environment.lighting.resource = nil
                arView.environment.background = .color(.systemBackground)
                arView.renderOptions.insert(.disableMotionBlur)
                arView.renderOptions.insert(.disableDepthOfField)

            } catch {
                print("❌ Failed to load model: \(error)")
            }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a lit#imageLiteral(resourceName: "simulator_screenshot_0EFAB2A3-2DA4-4279-AFC7-3CDAC65935B1.png")tle preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
