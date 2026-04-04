import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseFirestore

class ResultsViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var takeawaysLabel: UILabel!

    @IBOutlet weak var homeButton: UIButton!
    var isAtHome: Bool = false

    let experiment: Experiment
    private let db = Firestore.firestore()
    private var hasAwardedXP = false

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

        takeawaysLabel.text = experiment.results
        playLoopingVideo()

        // Award XP for completing the experiment
        awardExperienceForCompletion()
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

    // MARK: - Experience Award

    private func awardExperienceForCompletion() {
        guard !hasAwardedXP else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Check if this experiment has already been completed
        let experimentId = getExperimentId(for: experiment.title)

        db.collection("users").document(uid).collection("progress").document(experimentId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Error checking experiment progress: \(error.localizedDescription)")
                return
            }

            let data = snapshot?.data()
            let status = data?["status"] as? String

            // Only award XP if not already completed
            if status != "Completed" {
                // Mark experiment as completed
                self.db.collection("users").document(uid).collection("progress").document(experimentId).setData([
                    "status": "Completed",
                    "progress": 1.0,
                    "updatedAt": FieldValue.serverTimestamp()
                ], merge: true) { error in
                    if let error = error {
                        print("❌ Error marking experiment complete: \(error.localizedDescription)")
                        return
                    }

                    // Unlock next experiment after completion
                    self.unlockNextExperiment(currentExperimentId: experimentId, uid: uid)

                    // Check for achievement unlocks
                    ExperienceManager.shared.checkAndUnlockAchievements { success in
                        if success {
                            print("✅ Achievements checked after experiment completion")
                        }
                    }
                }

                // Award XP
                ExperienceManager.shared.awardExperience(amount: ExperienceManager.XPReward.experimentCompleted.rawValue) { success, error in
                    if success {
                        print("✅ Awarded \(ExperienceManager.XPReward.experimentCompleted.rawValue) XP for completing: \(self.experiment.title)")
                        self.hasAwardedXP = true

                        // Show XP earned notification
                        DispatchQueue.main.async {
                            self.showXPEarnedNotification(amount: ExperienceManager.XPReward.experimentCompleted.rawValue)
                        }
                    } else if let error = error {
                        print("❌ Error awarding XP: \(error.localizedDescription)")
                    }
                }
            } else {
                print("ℹ️ Experiment already completed, no XP awarded")
            }
        }
    }

    private func getExperimentId(for title: String) -> String {
        // Create a consistent ID from the experiment title
        return title.lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
    }

    private func unlockNextExperiment(currentExperimentId: String, uid: String) {
        // Fetch all experiments ordered by "order" field
        db.collection("experiments")
            .order(by: "order")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error fetching experiments: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                // Find current experiment's order
                var currentOrder: Int? = nil
                for doc in documents {
                    if doc.documentID == currentExperimentId {
                        currentOrder = doc.data()["order"] as? Int
                        break
                    }
                }

                guard let currentOrder = currentOrder else {
                    print("❌ Could not find current experiment order")
                    return
                }

                // Find next experiment (next order number)
                for doc in documents {
                    let order = doc.data()["order"] as? Int ?? 0
                    if order == currentOrder + 1 {
                        let nextExperimentId = doc.documentID

                        // Create progress document for next experiment
                        self.db.collection("users").document(uid)
                            .collection("progress").document(nextExperimentId)
                            .setData([
                                "status": "In Progress",
                                "progress": 0.0,
                                "updatedAt": FieldValue.serverTimestamp()
                            ], merge: true) { error in
                                if let error = error {
                                    print("❌ Error unlocking next experiment: \(error.localizedDescription)")
                                } else {
                                    print("✅ Unlocked next experiment: \(nextExperimentId)")
                                }
                            }
                        return
                    }
                }

                print("ℹ️ No next experiment to unlock (last experiment completed)")
            }
    }

    private func showXPEarnedNotification(amount: Int) {
        // Create a simple notification view
        let notificationView = UIView()
        notificationView.backgroundColor = UIColor(red: 214/255, green: 176/255, blue: 255/255, alpha: 1)
        notificationView.layer.cornerRadius = 12
        notificationView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "bolt.fill")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "+\(amount) XP"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        notificationView.addSubview(iconImageView)
        notificationView.addSubview(label)
        view.addSubview(notificationView)

        NSLayoutConstraint.activate([
            notificationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            notificationView.heightAnchor.constraint(equalToConstant: 50),
            notificationView.widthAnchor.constraint(equalToConstant: 150),

            iconImageView.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor)
        ])

        // Animate in
        notificationView.alpha = 0
        notificationView.transform = CGAffineTransform(translationX: 0, y: -20)

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            notificationView.alpha = 1
            notificationView.transform = .identity
        }) { _ in
            // Animate out after 2 seconds
            UIView.animate(withDuration: 0.3, delay: 2.0, options: [], animations: {
                notificationView.alpha = 0
                notificationView.transform = CGAffineTransform(translationX: 0, y: -20)
            }) { _ in
                notificationView.removeFromSuperview()
            }
        }
    }
}
