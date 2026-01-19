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
    
    let experiment: Experiment
    
    init(experiment: Experiment) {
        self.experiment = experiment
        super.init(nibName: "Results", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Round the video container
        videoView.layer.cornerRadius = 20
        videoView.clipsToBounds = true

        takeawaysLabel.text = experiment.Results
        playLoopingVideo()
    }

    @IBAction func homeButtonPressed(_ sender: UIButton) {
        // Transition to home screen (tab bar)
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: false)
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
