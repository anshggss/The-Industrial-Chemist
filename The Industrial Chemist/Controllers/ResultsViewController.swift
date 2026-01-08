//
//  ResultsViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 10/11/25.
//

import UIKit
import AVFoundation

class ResultsViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var takeawaysLabel: UILabel!
    
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


    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Round the video container
        videoView.layer.cornerRadius = 20
        videoView.clipsToBounds = true

        takeawaysLabel.text = ammoniaExperiment.Results
        playLoopingVideo()
    }

    
    override func viewIsAppearing(_ animated: Bool) {
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer?.frame = videoView.bounds
    }

    private func playLoopingVideo() {
        guard let videoURL = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
            print("Video file not found")
            return
        }

        player = AVPlayer(url: videoURL)
        player?.isMuted = true   // Optional: mute video

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoView.bounds
        playerLayer?.videoGravity = .resizeAspect   // Fits inside view

        if let playerLayer = playerLayer {
            videoView.layer.addSublayer(playerLayer)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loopVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )

        player?.play()
    }

    @objc private func loopVideo() {
        player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        player?.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
