import UIKit

class Profile2ViewController: UIViewController {

    // MARK: - State
    private var isLoading = false
    private var userStats: UserStats?
    private var achievements: [Achievement] = []

    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Lifecycle

    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { super.init(coder: coder) }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfileData()
    }

    // MARK: - Setup

    private func setupNav() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = false

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.titleTextAttributes = [.foregroundColor: AppColors.cardPrimary]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = AppColors.cardPrimary

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(settingsPressed)
        )
    }

    private func setupTableView() {
        view.backgroundColor = AppColors.background
        tableView.backgroundColor = AppColors.background
        tableView.separatorColor = AppColors.cardPrimary.withAlphaComponent(0.12)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.tableHeaderView = makeProfileHeader()
    }

    private func makeProfileHeader() -> UIView {
        let width = UIScreen.main.bounds.width
        let container = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 110))

        let avatar = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        avatar.tintColor = AppColors.progress
        avatar.contentMode = .scaleAspectFit
        avatar.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = UserManager.shared.currentUser?.name ?? "—"
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = AppColors.cardPrimary
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let emailLabel = UILabel()
        emailLabel.text = UserManager.shared.currentUser?.email ?? ""
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailLabel.textColor = AppColors.cardPrimary.withAlphaComponent(0.55)
        emailLabel.textAlignment = .center
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(avatar)
        container.addSubview(nameLabel)
        container.addSubview(emailLabel)

        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            avatar.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.heightAnchor.constraint(equalToConstant: 60),

            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            emailLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])

        return container
    }

    // MARK: - Data Loading

    private func loadProfileData() {
        guard !isLoading else { return }
        isLoading = true
        navigationItem.rightBarButtonItem?.isEnabled = false

        let group = DispatchGroup()
        var statsResult: UserStats?
        var achievementsResult: [String] = []
        var fetchError: Error?

        group.enter()
        ExperienceManager.shared.getUserStats { stats in
            statsResult = stats
            if stats == nil { fetchError = NSError(domain: "Profile", code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Failed to load stats"]) }
            group.leave()
        }

        group.enter()
        ExperienceManager.shared.getUnlockedAchievements { unlocked in
            achievementsResult = unlocked ?? []
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            if let error = fetchError {
                self.showError(error)
            } else {
                self.userStats = statsResult
                self.achievements = Achievement.withUnlockedIds(achievementsResult)
                self.tableView.tableHeaderView = self.makeProfileHeader()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Actions

    @objc private func settingsPressed() {
        let settingsVC = SettingsViewController(nibName: "Settings", bundle: nil)
        let nav = UINavigationController(rootViewController: settingsVC)
        nav.modalPresentationStyle = .automatic
        present(nav, animated: true)
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in self?.loadProfileData() })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Table

extension Profile2ViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 4 : achievements.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Stats" : "Achievements"
    }

    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = AppColors.cardPrimary.withAlphaComponent(0.6)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = AppColors.cardPrimary.withAlphaComponent(0.07)

        if indexPath.section == 0 {
            configureStatCell(cell, row: indexPath.row)
        } else {
            configureAchievementCell(cell, achievement: achievements[indexPath.row])
        }
        return cell
    }

    private func configureStatCell(_ cell: UITableViewCell, row: Int) {
        var config = cell.defaultContentConfiguration()

        let (icon, color, title, value): (String, UIColor, String, String) = {
            switch row {
            case 0: return ("flame.fill",   .systemOrange, "Streak",           userStats.map { "\($0.streak) days" } ?? "—")
            case 1: return ("bolt.fill",    .systemYellow, "Total XP",         userStats.map { "\($0.totalXP) XP" } ?? "—")
            case 2: return ("shield.fill",  AppColors.progress, "Division",    userStats?.division.rawValue ?? "—")
            default: return ("trophy.fill", .systemBlue,   "Leaderboard Rank", userStats.map { "#\($0.rank)" } ?? "—")
            }
        }()

        config.image = UIImage(systemName: icon)
        config.imageProperties.tintColor = color
        config.text = title
        config.textProperties.color = AppColors.cardPrimary
        config.secondaryText = value
        config.secondaryTextProperties.color = AppColors.cardPrimary.withAlphaComponent(0.55)
        cell.contentConfiguration = config
    }

    private func configureAchievementCell(_ cell: UITableViewCell, achievement: Achievement) {
        var config = cell.defaultContentConfiguration()
        config.image = UIImage(systemName: "rosette")
        config.imageProperties.tintColor = achievement.isUnlocked ? .systemYellow : AppColors.cardPrimary.withAlphaComponent(0.2)
        config.text = achievement.title
        config.textProperties.color = achievement.isUnlocked ? AppColors.cardPrimary : AppColors.cardPrimary.withAlphaComponent(0.4)
        config.secondaryText = achievement.description
        config.secondaryTextProperties.color = AppColors.cardPrimary.withAlphaComponent(0.35)
        cell.contentConfiguration = config
    }
}
