import UIKit
import AVFoundation

class ResultsViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var takeawaysLabel: UILabel!
    
    @IBOutlet weak var homeButton: UIButton!
    var isAtHome: Bool = false

    let experiment: Experiment

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    init(experiment: Experiment) {
        self.experiment = experiment
        super.init(nibName: "Results", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isAtHome {
            // remove Home button
            homeButton.isHidden = true
        }

        videoView.layer.cornerRadius = 20
        videoView.clipsToBounds = true

        takeawaysLabel.text = experiment.Results
        playLoopingVideo()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoView.bounds
    }

    @IBAction func homeButtonPressed(_ sender: UIButton) {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: false)
    }

    private func playLoopingVideo() {

        let videoName: String

        if experiment.title == "Ammonia Process" {
            videoName = "ammonia"
        } else {
            videoName = "ostwald"
        }

        guard let videoURL = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("Video file not found")
            return
        }

        player = AVPlayer(url: videoURL)
        player?.isMuted = true

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = videoView.bounds

        if let layer = playerLayer {
            videoView.layer.addSublayer(layer)
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
        player?.seek(to: .zero)
        player?.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
