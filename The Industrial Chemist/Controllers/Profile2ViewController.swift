//
//  Profile2ViewController.swift
//  The Industrial Chemist
//
//  Created by user@14 on 15/12/25.
//

import UIKit

class Profile2ViewController: UIViewController {
    // MARK: - User Info Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    // MARK: - Stats Outlets
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var rubyLabel: UILabel!
    @IBOutlet weak var topFinishLabel: UILabel!

    // MARK: - Achievement Outlets
    @IBOutlet weak var achievement1ImageView: UIImageView!
    @IBOutlet weak var achievement2ImageView: UIImageView!
    @IBOutlet weak var achievement3ImageView: UIImageView!
    @IBOutlet weak var achievement4ImageView: UIImageView!

    @IBOutlet weak var achievement1Label: UILabel!
    @IBOutlet weak var achievement2Label: UILabel!
    @IBOutlet weak var achievement3Label: UILabel!
    @IBOutlet weak var achievement4Label: UILabel!

    // MARK: - Other Outlets
    @IBOutlet weak var settingsButton: UIButton!

    // MARK: - Properties
    private var loadingView: UIView?
    private var isLoading: Bool = false
    private var userStats: UserStats?
    private var achievements: [Achievement] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Subscribe to stats updates (XP, rank, etc)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleStatsUpdate),
            name: ExperienceManager.statsUpdatedNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleStatsUpdate() {
        loadProfileData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfileData()
    }

    // MARK: - Setup
    private func setupUI() {
        if let user = UserManager.shared.currentUser {
            usernameLabel.text = user.name
        }
    }

    // MARK: - Data Loading
    private func loadProfileData() {
        guard !isLoading else { return }
        isLoading = true
        showLoading()

        let group = DispatchGroup()
        var statsResult: UserStats?
        var achievementsResult: [String]?
        var fetchError: Error?

        // Fetch user stats
        group.enter()
        ExperienceManager.shared.getUserStats { stats in
            statsResult = stats
            if stats == nil {
                fetchError = NSError(domain: "Profile", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to load profile stats"])
            }
            group.leave()
        }

        // Fetch achievements
        group.enter()
        ExperienceManager.shared.getUnlockedAchievements { unlocked in
            achievementsResult = unlocked ?? []
            group.leave()
        }

        // Wait for both to complete
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.hideLoading()

            if let error = fetchError {
                self.showErrorAlert(error: error)
            } else {
                self.userStats = statsResult
                self.achievements = Achievement.withUnlockedIds(achievementsResult ?? [])
                self.refreshUI()
            }
        }
    }

    // MARK: - UI Updates
    private func refreshUI() {
        // Update username
        if let user = UserManager.shared.currentUser {
            usernameLabel.text = user.name
        }

        // Update stats
        if let stats = userStats {
            streakLabel.text = "\(stats.streak) days"
            xpLabel.text = "\(stats.totalXP) XP"
            rubyLabel.text = stats.division.rawValue
            topFinishLabel.text = "#\(stats.rank)"
        }

        // Update achievements
        updateAchievementsUI()
    }

    private func updateAchievementsUI() {
        let imageViews = [achievement1ImageView, achievement2ImageView,
                          achievement3ImageView, achievement4ImageView]
        let labels = [achievement1Label, achievement2Label,
                      achievement3Label, achievement4Label]

        for (index, achievement) in achievements.enumerated() {
            guard index < imageViews.count else { break }

            if achievement.isUnlocked {
                imageViews[index]?.image = UIImage(named: achievement.imageName)
                imageViews[index]?.alpha = 1.0
                labels[index]?.text = achievement.title
                labels[index]?.alpha = 1.0
            } else {
                imageViews[index]?.image = UIImage(named: achievement.imageName)
                imageViews[index]?.alpha = 0.3
                labels[index]?.text = "Locked"
                labels[index]?.alpha = 0.5
            }
        }
    }

    // MARK: - Loading State
    private func showLoading() {
        // Remove existing loading view if any
        loadingView?.removeFromSuperview()

        // Create semi-transparent overlay
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Add activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = overlay.center
        activityIndicator.startAnimating()
        overlay.addSubview(activityIndicator)

        view.addSubview(overlay)
        loadingView = overlay
        view.isUserInteractionEnabled = false
    }

    private func hideLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
        view.isUserInteractionEnabled = true
    }

    // MARK: - Error Handling
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Error Loading Profile",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadProfileData()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    // MARK: - Actions
    @IBAction func settingsPressed(_ sender: UIButton) {
        let vc = SettingsViewController(nibName: "Settings", bundle: nil)

        vc.modalPresentationStyle = .automatic
        vc.modalTransitionStyle = .coverVertical

        self.present(vc, animated: true, completion: nil)
    }
}
