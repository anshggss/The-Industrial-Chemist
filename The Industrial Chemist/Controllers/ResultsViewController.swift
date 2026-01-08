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

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        playLoopingVideo()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoView.bounds
    }

    private func playLoopingVideo() {
        guard let videoURL = Bundle.main.url(forResource: "sample", withExtension: "mov") else {
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
