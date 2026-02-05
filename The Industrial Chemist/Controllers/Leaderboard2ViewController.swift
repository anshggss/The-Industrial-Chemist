import UIKit

// MARK: - Models

struct UserStats {
    let streak: Int
    let totalXP: Int
    let weeklyXP: Int
    let rank: Int
    let division: Division
}

enum Division: String {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    case diamond = "Diamond"
    case master = "Master"
    
    var imageName: String {
        switch self {
        case .bronze: return "shield.fill"
        case .silver: return "shield.lefthalf.filled"
        case .gold: return "shield.checkered"
        case .platinum: return "star.shield.fill"
        case .diamond: return "diamond.fill"
        case .master: return "crown.fill"
        }
    }
    
    var color: UIColor {
        switch self {
        case .bronze: return UIColor(hex: "#CD7F32")
        case .silver: return UIColor(hex: "#C0C0C0")
        case .gold: return UIColor(hex: "#FFD700")
        case .platinum: return UIColor(hex: "#E5E4E2")
        case .diamond: return UIColor(hex: "#B9F2FF")
        case .master: return UIColor(hex: "#9D4EDD")
        }
    }
    
    var nextDivision: Division? {
        switch self {
        case .bronze: return .silver
        case .silver: return .gold
        case .gold: return .platinum
        case .platinum: return .diamond
        case .diamond: return .master
        case .master: return nil
        }
    }
    
    var xpRequired: Int {
        switch self {
        case .bronze: return 0
        case .silver: return 500
        case .gold: return 1500
        case .platinum: return 3000
        case .diamond: return 5000
        case .master: return 10000
        }
    }
}

// MARK: - LeaderboardViewController

class Leaderboard2ViewController: UIViewController {
    
    // MARK: - Dummy Data
    
    private let userStats = UserStats(
        streak: 12,
        totalXP: 2450,
        weeklyXP: 380,
        rank: 5,
        division: .gold
    )
    
    private let leaderboardData: [LeaderboardEntry] = [
        LeaderboardEntry(rank: 1, name: "ChemMaster99", xp: 1250, profileImage: nil),
        LeaderboardEntry(rank: 2, name: "ScienceQueen", xp: 1180, profileImage: nil),
        LeaderboardEntry(rank: 3, name: "LabRat2024", xp: 1050, profileImage: nil),
        LeaderboardEntry(rank: 4, name: "MoleculeMan", xp: 920, profileImage: nil),
        LeaderboardEntry(rank: 5, name: "You", xp: 380, profileImage: nil),
        LeaderboardEntry(rank: 6, name: "AtomicAnna", xp: 340, profileImage: nil),
        LeaderboardEntry(rank: 7, name: "ReactionKing", xp: 290, profileImage: nil),
        LeaderboardEntry(rank: 8, name: "BunsenBurner", xp: 245, profileImage: nil),
        LeaderboardEntry(rank: 9, name: "PeriodicPete", xp: 180, profileImage: nil),
        LeaderboardEntry(rank: 10, name: "CatalystCat", xp: 120, profileImage: nil)
    ]
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Leaderboard"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.cardPrimary
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let divisionCardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.cardPrimary
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let weeklyLeaderboardLabel: UILabel = {
        let label = UILabel()
        label.text = "Weekly Leaderboard"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.text = "⏱ 3 days left"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColors.cardPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var tableHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupUI()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
                self.tableHeightConstraint?.constant = self.tableView.contentSize.height
                self.view.layoutIfNeeded()
            }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(statsContainerView)
        contentView.addSubview(divisionCardView)
        contentView.addSubview(weeklyLeaderboardLabel)
        contentView.addSubview(timeRemainingLabel)
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Stats Container
            statsContainerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            statsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statsContainerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Division Card
            divisionCardView.topAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: 16),
            divisionCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divisionCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divisionCardView.heightAnchor.constraint(equalToConstant: 160),
            
            // Weekly Leaderboard Label
            weeklyLeaderboardLabel.topAnchor.constraint(equalTo: divisionCardView.bottomAnchor, constant: 24),
            weeklyLeaderboardLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Time Remaining
            timeRemainingLabel.centerYAnchor.constraint(equalTo: weeklyLeaderboardLabel.centerYAnchor),
            timeRemainingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: weeklyLeaderboardLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Calculate based on number of rows (80 height per row + some padding)
        let tableHeight = CGFloat(leaderboardData.count) * 80 + 20
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableHeight)
        tableHeightConstraint?.isActive = true
        
        setupStatsContainer()
        setupDivisionCard()
    }
    
    // MARK: - Stats Container
    
    private func setupStatsContainer() {
        // Streak View
        let streakView = createStatCard(
            icon: "flame.fill",
            iconColor: UIColor(hex: "#FF6B35"),
            iconBackgroundColor: UIColor(hex: "#FF6B35").withAlphaComponent(0.2),
            value: "\(userStats.streak)",
            label: "Day Streak"
        )
        
        // Total XP View
        let totalXPView = createStatCard(
            icon: "bolt.fill",
            iconColor: AppColors.progress,
            iconBackgroundColor: AppColors.progress.withAlphaComponent(0.2),
            value: "\(userStats.totalXP)",
            label: "Total XP"
        )
        
        // Rank View
        let rankView = createStatCard(
            icon: "trophy.fill",
            iconColor: UIColor(hex: "#FFD700"),
            iconBackgroundColor: UIColor(hex: "#FFD700").withAlphaComponent(0.2),
            value: "#\(userStats.rank)",
            label: "Your Rank"
        )
        
        // Stack View
        let stackView = UIStackView(arrangedSubviews: [streakView, totalXPView, rankView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        statsContainerView.addSubview(stackView)
        
        // Make container transparent (cards inside will have background)
        statsContainerView.backgroundColor = .clear
        statsContainerView.layer.shadowOpacity = 0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: statsContainerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor)
        ])
    }
    
    private func createStatCard(icon: String, iconColor: UIColor, iconBackgroundColor: UIColor, value: String, label: String) -> UIView {
        // Card Container
        let card = UIView()
        card.backgroundColor = AppColors.cardPrimary
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.1
        card.layer.shadowRadius = 6
        card.layer.shadowOffset = CGSize(width: 0, height: 3)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon Background Circle
        let iconBackground = UIView()
        iconBackground.backgroundColor = iconBackgroundColor
        iconBackground.layer.cornerRadius = 20
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon Image
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = iconColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Value Label
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = AppColors.textPrimary
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.font = .systemFont(ofSize: 11, weight: .medium)
        titleLabel.textColor = AppColors.textPrimary.withAlphaComponent(0.6)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        card.addSubview(iconBackground)
        iconBackground.addSubview(iconImageView)
        card.addSubview(valueLabel)
        card.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Icon Background
            iconBackground.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            iconBackground.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            iconBackground.widthAnchor.constraint(equalToConstant: 40),
            iconBackground.heightAnchor.constraint(equalToConstant: 40),
            
            // Icon Image
            iconImageView.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Value Label
            valueLabel.topAnchor.constraint(equalTo: iconBackground.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -4),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -12)
        ])
        
        return card
    }

    
//    private func createStatView(icon: String, iconColor: UIColor, value: String, label: String) -> UIView {
//        let container = UIView()
//        container.translatesAutoresizingMaskIntoConstraints = false
//        
//        let iconView = UIImageView()
//        iconView.image = UIImage(systemName: icon)
//        iconView.tintColor = iconColor
//        iconView.contentMode = .scaleAspectFit
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let valueLabel = UILabel()
//        valueLabel.text = value
//        valueLabel.font = .systemFont(ofSize: 22, weight: .bold)
//        valueLabel.textColor = AppColors.textPrimary
//        valueLabel.textAlignment = .center
//        valueLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        let titleLabel = UILabel()
//        titleLabel.text = label
//        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
//        titleLabel.textColor = AppColors.textPrimary.withAlphaComponent(0.6)
//        titleLabel.textAlignment = .center
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        container.addSubview(iconView)
//        container.addSubview(valueLabel)
//        container.addSubview(titleLabel)
//        
//        NSLayoutConstraint.activate([
//            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
//            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            iconView.widthAnchor.constraint(equalToConstant: 24),
//            iconView.heightAnchor.constraint(equalToConstant: 24),
//            
//            valueLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 6),
//            valueLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
//            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
//            
//            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
//            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
//            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4)
//        ])
//        
//        return container
//    }
    
//    private func createDivider() -> UIView {
//        let divider = UIView()
//        divider.backgroundColor = AppColors.textPrimary.withAlphaComponent(0.15)
//        divider.translatesAutoresizingMaskIntoConstraints = false
//        return divider
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload and update height
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableHeightConstraint?.constant = tableView.contentSize.height
    }
    // MARK: - Division Card
    
    private func setupDivisionCard() {
        // Division Icon Container
        let divisionIconContainer = UIView()
        divisionIconContainer.backgroundColor = userStats.division.color.withAlphaComponent(0.2)
        divisionIconContainer.layer.cornerRadius = 35
        divisionIconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let divisionIcon = UIImageView()
        divisionIcon.image = UIImage(systemName: userStats.division.imageName)
        divisionIcon.tintColor = userStats.division.color
        divisionIcon.contentMode = .scaleAspectFit
        divisionIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Division Info
        let divisionLabel = UILabel()
        divisionLabel.text = userStats.division.rawValue
        divisionLabel.font = .systemFont(ofSize: 24, weight: .bold)
        divisionLabel.textColor = AppColors.textPrimary
        divisionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let divisionSubtitle = UILabel()
        divisionSubtitle.text = "Current Division"
        divisionSubtitle.font = .systemFont(ofSize: 14, weight: .medium)
        divisionSubtitle.textColor = AppColors.textPrimary.withAlphaComponent(0.6)
        divisionSubtitle.translatesAutoresizingMaskIntoConstraints = false
        
        // Weekly XP Badge
        let weeklyBadge = UIView()
        weeklyBadge.backgroundColor = AppColors.progress.withAlphaComponent(0.2)
        weeklyBadge.layer.cornerRadius = 12
        weeklyBadge.translatesAutoresizingMaskIntoConstraints = false
        
        let weeklyLabel = UILabel()
        weeklyLabel.text = "+\(userStats.weeklyXP) XP this week"
        weeklyLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        weeklyLabel.textColor = AppColors.progress
        weeklyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Progress Container
        let progressContainer = UIView()
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let progressLabel = UILabel()
        if let nextDiv = userStats.division.nextDivision {
            let xpNeeded = nextDiv.xpRequired - userStats.totalXP
            progressLabel.text = "\(xpNeeded) XP to \(nextDiv.rawValue)"
        } else {
            progressLabel.text = "Max Division Reached! 🎉"
        }
        progressLabel.font = .systemFont(ofSize: 12, weight: .medium)
        progressLabel.textColor = AppColors.textPrimary.withAlphaComponent(0.7)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progressTintColor = userStats.division.color
        progressBar.trackTintColor = userStats.division.color.withAlphaComponent(0.2)
        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Calculate progress
        if let nextDiv = userStats.division.nextDivision {
            let currentMin = userStats.division.xpRequired
            let nextMin = nextDiv.xpRequired
            let progress = Float(userStats.totalXP - currentMin) / Float(nextMin - currentMin)
            progressBar.progress = min(max(progress, 0), 1)
        } else {
            progressBar.progress = 1.0
        }
        
        // Add subviews
        divisionCardView.addSubview(divisionIconContainer)
        divisionIconContainer.addSubview(divisionIcon)
        divisionCardView.addSubview(divisionLabel)
        divisionCardView.addSubview(divisionSubtitle)
        divisionCardView.addSubview(weeklyBadge)
        weeklyBadge.addSubview(weeklyLabel)
        divisionCardView.addSubview(progressContainer)
        progressContainer.addSubview(progressLabel)
        progressContainer.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            // Division Icon Container
            divisionIconContainer.leadingAnchor.constraint(equalTo: divisionCardView.leadingAnchor, constant: 20),
            divisionIconContainer.topAnchor.constraint(equalTo: divisionCardView.topAnchor, constant: 20),
            divisionIconContainer.widthAnchor.constraint(equalToConstant: 70),
            divisionIconContainer.heightAnchor.constraint(equalToConstant: 70),
            
            divisionIcon.centerXAnchor.constraint(equalTo: divisionIconContainer.centerXAnchor),
            divisionIcon.centerYAnchor.constraint(equalTo: divisionIconContainer.centerYAnchor),
            divisionIcon.widthAnchor.constraint(equalToConstant: 36),
            divisionIcon.heightAnchor.constraint(equalToConstant: 36),
            
            // Division Label
            divisionLabel.leadingAnchor.constraint(equalTo: divisionIconContainer.trailingAnchor, constant: 16),
            divisionLabel.topAnchor.constraint(equalTo: divisionIconContainer.topAnchor, constant: 8),
            
            // Division Subtitle
            divisionSubtitle.leadingAnchor.constraint(equalTo: divisionLabel.leadingAnchor),
            divisionSubtitle.topAnchor.constraint(equalTo: divisionLabel.bottomAnchor, constant: 4),
            
            // Weekly Badge
            weeklyBadge.trailingAnchor.constraint(equalTo: divisionCardView.trailingAnchor, constant: -20),
            weeklyBadge.topAnchor.constraint(equalTo: divisionCardView.topAnchor, constant: 20),
            weeklyBadge.heightAnchor.constraint(equalToConstant: 28),
            
            weeklyLabel.leadingAnchor.constraint(equalTo: weeklyBadge.leadingAnchor, constant: 12),
            weeklyLabel.trailingAnchor.constraint(equalTo: weeklyBadge.trailingAnchor, constant: -12),
            weeklyLabel.centerYAnchor.constraint(equalTo: weeklyBadge.centerYAnchor),
            
            // Progress Container
            progressContainer.leadingAnchor.constraint(equalTo: divisionCardView.leadingAnchor, constant: 20),
            progressContainer.trailingAnchor.constraint(equalTo: divisionCardView.trailingAnchor, constant: -20),
            progressContainer.bottomAnchor.constraint(equalTo: divisionCardView.bottomAnchor, constant: -20),
            progressContainer.heightAnchor.constraint(equalToConstant: 40),
            
            progressLabel.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressLabel.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            
            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        // Add shadow
        divisionCardView.layer.shadowColor = UIColor.black.cgColor
        divisionCardView.layer.shadowOpacity = 0.15
        divisionCardView.layer.shadowRadius = 10
        divisionCardView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    // MARK: - Table View Setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
    }
}

// MARK: - UITableViewDelegate & DataSource

extension Leaderboard2ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let entry = leaderboardData[indexPath.row]
        cell.configure(with: entry)
        return cell
    }
}

// MARK: - LeaderboardCell

class LeaderboardCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rankBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 22
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let crownImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "crown.fill")
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let xpContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let xpIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bolt.fill")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let xpLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let youBadge: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.inProgress
        view.layer.cornerRadius = 8
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let youLabel: UILabel = {
        let label = UILabel()
        label.text = "YOU"
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(rankBadgeView)
        rankBadgeView.addSubview(rankLabel)
        containerView.addSubview(profileImageView)
        containerView.addSubview(crownImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(youBadge)
        youBadge.addSubview(youLabel)
        containerView.addSubview(xpContainerView)
        xpContainerView.addSubview(xpIconView)
        xpContainerView.addSubview(xpLabel)
        
        // Container shadow
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // Rank Badge
            rankBadgeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            rankBadgeView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rankBadgeView.widthAnchor.constraint(equalToConstant: 28),
            rankBadgeView.heightAnchor.constraint(equalToConstant: 28),
            
            rankLabel.centerXAnchor.constraint(equalTo: rankBadgeView.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankBadgeView.centerYAnchor),
            
            // Profile Image
            profileImageView.leadingAnchor.constraint(equalTo: rankBadgeView.trailingAnchor, constant: 12),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 44),
            profileImageView.heightAnchor.constraint(equalToConstant: 44),
            
            // Crown
            crownImageView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            crownImageView.bottomAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 6),
            crownImageView.widthAnchor.constraint(equalToConstant: 20),
            crownImageView.heightAnchor.constraint(equalToConstant: 16),
            
            // Name Label
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // You Badge
            youBadge.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            youBadge.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            youBadge.heightAnchor.constraint(equalToConstant: 18),
            
            youLabel.leadingAnchor.constraint(equalTo: youBadge.leadingAnchor, constant: 6),
            youLabel.trailingAnchor.constraint(equalTo: youBadge.trailingAnchor, constant: -6),
            youLabel.centerYAnchor.constraint(equalTo: youBadge.centerYAnchor),
            
            // XP Container
            xpContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            xpContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            xpContainerView.heightAnchor.constraint(equalToConstant: 28),
            
            // XP Icon
            xpIconView.leadingAnchor.constraint(equalTo: xpContainerView.leadingAnchor, constant: 8),
            xpIconView.centerYAnchor.constraint(equalTo: xpContainerView.centerYAnchor),
            xpIconView.widthAnchor.constraint(equalToConstant: 14),
            xpIconView.heightAnchor.constraint(equalToConstant: 14),
            
            // XP Label
            xpLabel.leadingAnchor.constraint(equalTo: xpIconView.trailingAnchor, constant: 4),
            xpLabel.trailingAnchor.constraint(equalTo: xpContainerView.trailingAnchor, constant: -10),
            xpLabel.centerYAnchor.constraint(equalTo: xpContainerView.centerYAnchor)
        ])
    }
    
    // MARK: - Configure
    
    func configure(with entry: LeaderboardEntry) {
        rankLabel.text = "\(entry.rank)"
        nameLabel.text = entry.name
        xpLabel.text = "\(entry.xp) XP"
        profileImageView.image = entry.profileImage ?? UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = AppColors.icon
        
        // Check if this is the current user
        let isCurrentUser = entry.name == "You"
        youBadge.isHidden = !isCurrentUser
        
        applyRankStyling(rank: entry.rank, isCurrentUser: isCurrentUser)
    }
    
    private func applyRankStyling(rank: Int, isCurrentUser: Bool) {
        // Default styling
        nameLabel.textColor = AppColors.textPrimary
        xpContainerView.backgroundColor = AppColors.progress.withAlphaComponent(0.15)
        xpIconView.tintColor = AppColors.progress
        xpLabel.textColor = AppColors.progress
        
        // Highlight current user
        if isCurrentUser {
            containerView.backgroundColor = AppColors.cardPrimary
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = AppColors.inProgress.cgColor
        } else {
            containerView.backgroundColor = AppColors.cardPrimary
            containerView.layer.borderWidth = 0
        }
        
        switch rank {
        case 1:
            // 🥇 Gold - 1st Place
            let goldColor = UIColor(hex: "#FFD700")
            
            rankBadgeView.backgroundColor = goldColor
            rankLabel.textColor = AppColors.textPrimary
            
            if !isCurrentUser {
                containerView.layer.borderWidth = 2
                containerView.layer.borderColor = goldColor.cgColor
            }
            
            profileImageView.layer.borderColor = goldColor.cgColor
            profileImageView.layer.borderWidth = 3
            
            crownImageView.tintColor = goldColor
            crownImageView.isHidden = false
            
        case 2:
            // 🥈 Silver - 2nd Place
            let silverColor = UIColor(hex: "#C0C0C0")
            
            rankBadgeView.backgroundColor = silverColor
            rankLabel.textColor = AppColors.textPrimary
            
            if !isCurrentUser {
                containerView.layer.borderWidth = 2
                containerView.layer.borderColor = silverColor.cgColor
            }
            
            profileImageView.layer.borderColor = silverColor.cgColor
            profileImageView.layer.borderWidth = 2
            
            crownImageView.isHidden = true
            
        case 3:
            // 🥉 Bronze - 3rd Place
            let bronzeColor = UIColor(hex: "#CD7F32")
            
            rankBadgeView.backgroundColor = bronzeColor
            rankLabel.textColor = .white
            
            if !isCurrentUser {
                containerView.layer.borderWidth = 2
                containerView.layer.borderColor = bronzeColor.cgColor
            }
            
            profileImageView.layer.borderColor = bronzeColor.cgColor
            profileImageView.layer.borderWidth = 2
            
            crownImageView.isHidden = true
            
        default:
            // Regular ranking (4th+)
            rankBadgeView.backgroundColor = AppColors.progress.withAlphaComponent(0.2)
            rankLabel.textColor = AppColors.textPrimary
            
            profileImageView.layer.borderColor = AppColors.progress.cgColor
            profileImageView.layer.borderWidth = 2
            
            crownImageView.isHidden = true
        }
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankLabel.text = nil
        nameLabel.text = nil
        xpLabel.text = nil
        profileImageView.image = nil
        containerView.layer.borderWidth = 0
        crownImageView.isHidden = true
        youBadge.isHidden = true
    }
}
