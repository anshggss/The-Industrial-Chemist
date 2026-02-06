import UIKit

class HomeScreenNativeViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let experiment = Experiment(
        title: "Ammonia Process",
        testExperiment: "Ammonia",
        Setup: [
            "Ensure the workspace is clean, well-ventilated, and safe before starting. Wear protective gear like gloves and safety goggles, and check all equipment, as ammonia preparation involves high pressure and temperature.",
            "The process is similar to using a pressure cooker. Increased pressure and controlled heat allow nitrogen and hydrogen to react efficiently in the presence of a catalyst to form ammonia."
        ],
        Build: [
            "The process uses components such as high-pressure reactors, compressors to raise gas pressure, heat exchangers for temperature control, and distillation columns to separate the formed ammonia."
        ],
        Theory: "The Haber–Bosch process synthesizes ammonia by reacting nitrogen and hydrogen at high pressure and moderate temperature using an iron-based catalyst to speed up the reaction.",
        Test: "N₂ + 3H₂ ⇌ 2NH₃",
        Results: "This experiment demonstrates how pressure, temperature, and catalysts are applied in industrial chemistry to produce ammonia, a key compound used in fertilizers and agriculture.",
        model: "ammonia"
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = AppColors.background
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        configureNavigationBar()
        setupTableView()
    }

    private func configureNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.titleTextAttributes = [.foregroundColor: AppColors.cardPrimary]
        appearance.largeTitleTextAttributes = [.foregroundColor: AppColors.cardPrimary]
        
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = AppColors.cardPrimary
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - Table Setup
extension HomeScreenNativeViewController: UITableViewDelegate, UITableViewDataSource {

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GreetingCell.self, forCellReuseIdentifier: GreetingCell.identifier)
        tableView.register(StreakTableViewCell.self, forCellReuseIdentifier: "StreakCell")
        tableView.register(LearningCardCell.self, forCellReuseIdentifier: LearningCardCell.identifier)
        tableView.register(LockedTopicCell.self, forCellReuseIdentifier: LockedTopicCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int { 4 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 3
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 2 || section == 3 else { return nil }
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = section == 2 ? "Continue Learning" : "More to Learn"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = AppColors.cardPrimary
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2, 3: return 50
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GreetingCell.identifier, for: indexPath) as? GreetingCell else {
                return UITableViewCell()
            }
            let name = UserManager.shared.currentUser?.name ?? "Chemist"
            cell.configure(name: name)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StreakCell", for: indexPath) as? StreakTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(days: 5)
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LearningCardCell.identifier, for: indexPath) as? LearningCardCell else {
                return UITableViewCell()
            }
            cell.configure(
                title: "The Haber–Bosch Process",
                subtitle: "Resume your last experiment",
                progress: 0.65,
                iconName: "flame.fill"
            )
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LockedTopicCell.identifier, for: indexPath) as? LockedTopicCell else {
                return UITableViewCell()
            }
            let topics = ["Oxygen Preparation", "Hydrogen Preparation", "Chlorine Preparation"]
            let icons = ["drop.fill", "bolt.fill", "leaf.fill"]
            cell.configure(title: topics[indexPath.row], iconName: icons[indexPath.row])
            return cell
            
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 2 else { return }

        let setUpVC = SetUpViewController(experiment: experiment, nib: "SetUp")
        setUpVC.isAtHome.toggle()

        let navController = UINavigationController(rootViewController: setUpVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

// MARK: - Greeting Cell

class GreetingCell: UITableViewCell {
    
    static let identifier = "GreetingCell"
    
    private let greetingLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        // Greeting
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        greetingLabel.textColor = AppColors.cardPrimary
        contentView.addSubview(greetingLabel)
        
        // Subtitle
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = AppColors.cardPrimary.withAlphaComponent(0.7)
        subtitleLabel.numberOfLines = 0
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(name: String) {
        greetingLabel.text = "\(getGreeting()), \(name) 👋"
        subtitleLabel.text = "Ready to ignite your inner chemist?"
    }
    
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }
}

// MARK: - Learning Card Cell
class LearningCardCell: UITableViewCell {
    
    static let identifier = "LearningCardCell"
    
    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let progressView = UIProgressView()
    private let progressLabel = UILabel()
    private let chevronImageView = UIImageView()
    private var gradientLayer: CAGradientLayer?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = iconContainerView.bounds
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = AppColors.cardPrimary
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.12
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        contentView.addSubview(containerView)
        
        // Icon Container
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.layer.cornerRadius = 14
        iconContainerView.clipsToBounds = true
        containerView.addSubview(iconContainerView)
        
        // Gradient for icon
        let gradient = CAGradientLayer()
        gradient.colors = [AppColors.progress.cgColor, AppColors.inProgress.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 14
        iconContainerView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Icon
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconContainerView.addSubview(iconImageView)
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = AppColors.textPrimary
        containerView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = AppColors.inProgress
        containerView.addSubview(subtitleLabel)
        
        // Progress View
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = AppColors.progressTrack
        progressView.progressTintColor = AppColors.progress
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        containerView.addSubview(progressView)
        
        // Progress Label
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        progressLabel.textColor = AppColors.progress
        containerView.addSubview(progressLabel)
        
        // Chevron
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.image = UIImage(systemName: "chevron.right.circle.fill")
        chevronImageView.tintColor = AppColors.progress
        chevronImageView.contentMode = .scaleAspectFit
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 52),
            iconContainerView.heightAnchor.constraint(equalToConstant: 52),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 26),
            iconImageView.heightAnchor.constraint(equalToConstant: 26),
            
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 28),
            chevronImageView.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            progressView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            progressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 120),
            progressView.heightAnchor.constraint(equalToConstant: 6),
            progressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18),
            
            progressLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            progressLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 10)
        ])
    }
    
    func configure(title: String, subtitle: String, progress: Float, iconName: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        progressView.progress = progress
        progressLabel.text = "\(Int(progress * 100))%"
        iconImageView.image = UIImage(systemName: iconName)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.containerView.transform = highlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            self.containerView.alpha = highlighted ? 0.9 : 1.0
        }
    }
}

// MARK: - Locked Topic Cell
class LockedTopicCell: UITableViewCell {
    
    static let identifier = "LockedTopicCell"
    
    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let lockBadge = UIView()
    private let lockIcon = UIImageView()
    private let comingSoonLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = AppColors.cardSecondary.withAlphaComponent(0.4)
        containerView.layer.cornerRadius = 14
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = AppColors.locked.withAlphaComponent(0.3).cgColor
        contentView.addSubview(containerView)
        
        // Icon Container
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = AppColors.locked.withAlphaComponent(0.2)
        iconContainerView.layer.cornerRadius = 12
        containerView.addSubview(iconContainerView)
        
        // Icon
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = AppColors.locked
        iconContainerView.addSubview(iconImageView)
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = AppColors.locked
        containerView.addSubview(titleLabel)
        
        // Lock Badge
        lockBadge.translatesAutoresizingMaskIntoConstraints = false
        lockBadge.backgroundColor = AppColors.locked.withAlphaComponent(0.2)
        lockBadge.layer.cornerRadius = 12
        containerView.addSubview(lockBadge)
        
        // Lock Icon
        lockIcon.translatesAutoresizingMaskIntoConstraints = false
        lockIcon.image = UIImage(systemName: "lock.fill")
        lockIcon.tintColor = AppColors.locked
        lockIcon.contentMode = .scaleAspectFit
        lockBadge.addSubview(lockIcon)
        
        // Coming Soon Label
        comingSoonLabel.translatesAutoresizingMaskIntoConstraints = false
        comingSoonLabel.text = "Soon"
        comingSoonLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        comingSoonLabel.textColor = AppColors.locked
        lockBadge.addSubview(comingSoonLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.heightAnchor.constraint(equalToConstant: 68),
            
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 44),
            iconContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            lockBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14),
            lockBadge.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            lockBadge.heightAnchor.constraint(equalToConstant: 26),
            
            lockIcon.leadingAnchor.constraint(equalTo: lockBadge.leadingAnchor, constant: 10),
            lockIcon.centerYAnchor.constraint(equalTo: lockBadge.centerYAnchor),
            lockIcon.widthAnchor.constraint(equalToConstant: 12),
            lockIcon.heightAnchor.constraint(equalToConstant: 12),
            
            comingSoonLabel.leadingAnchor.constraint(equalTo: lockIcon.trailingAnchor, constant: 5),
            comingSoonLabel.trailingAnchor.constraint(equalTo: lockBadge.trailingAnchor, constant: -10),
            comingSoonLabel.centerYAnchor.constraint(equalTo: lockBadge.centerYAnchor)
        ])
    }
    
    func configure(title: String, iconName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconName)
    }
}
