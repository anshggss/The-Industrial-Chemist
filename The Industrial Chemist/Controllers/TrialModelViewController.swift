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
        
        let boxSize: CGFloat = 300
                let boxFrame = CGRect(
                    x: (view.bounds.width - boxSize) / 2,
                    y: (view.bounds.height - boxSize) / 2,
                    width: boxSize,
                    height: boxSize
                )
                
                // Create ARView in non-AR mode
                arView = ARView(frame: boxFrame, cameraMode: .nonAR, automaticallyConfigureSession: false)
                arView.layer.cornerRadius = 20
                arView.clipsToBounds = true
                arView.backgroundColor = .systemBackground
                
                view.addSubview(arView)
                
                loadModel()
        
        
    }
    
    func loadModel() {
            do {
                // Load model entity
                let entity = try Entity.load(named: "computer")
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

    @IBAction func backButtonPressed(_ sender: UIButton) {
        let profileVC = ProfileViewController(nibName: "Profile", bundle: nil)
        profileVC.modalPresentationStyle = .fullScreen
        self.present(profileVC, animated: true, completion: nil)
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
