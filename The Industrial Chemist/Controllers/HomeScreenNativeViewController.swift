import UIKit
import FirebaseAuth
import FirebaseFirestore

final class HomeScreenNativeViewController: UIViewController {

    // MARK: - Firebase
    private let db = Firestore.firestore()

    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Home Data (from Firestore)
    private struct HomeExperimentItem {
        let id: String
        let title: String
        let status: String          // "Locked" / "In Progress" / "Completed"
        let progress: Double        // 0...1
        let experiment: Experiment? // built only if unlocked
        let iconName: String
    }

    private var continueItem: HomeExperimentItem?
    private var lockedItems: [HomeExperimentItem] = []

    private enum Section: Int, CaseIterable {
        case greeting = 0
        case streak = 1
        case continueLearning = 2
        case calendar = 3
        case moreToLearn = 4
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.backgroundColor = AppColors.background
        configureNavigationBar()
        setupTableView()

        fetchHomeData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh to reflect updated progress/status
        fetchHomeData()
    }

    // MARK: - Navigation Bar
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

    // MARK: - Firestore Fetch + Merge
    private func fetchHomeData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            continueItem = nil
            lockedItems = []
            tableView.reloadData()
            return
        }

        db.collection("experiments")
            .order(by: "order")
            .getDocuments { [weak self] expSnapshot, expError in
                guard let self = self else { return }

                if let expError = expError {
                    print("Home experiments fetch error: \(expError)")
                    return
                }

                let experimentDocs = expSnapshot?.documents ?? []

                self.db.collection("users")
                    .document(uid)
                    .collection("progress")
                    .getDocuments(completion: { [weak self] progSnapshot, progError in
                        guard let self = self else { return }

                        if let progError = progError {
                            print("Home progress fetch error: \(progError)")
                            return
                        }

                        // progress lookup: experimentId -> (status, progress)
                        var progressById: [String: (status: String, progress: Double)] = [:]
                        let progressDocs = progSnapshot?.documents ?? []

                        for doc in progressDocs {
                            let data = doc.data()
                            let status = data["status"] as? String ?? "Locked"
                            let progress = data["progress"] as? Double ?? 0.0
                            progressById[doc.documentID] = (status: status, progress: progress)
                        }

                        // Merge into items
                        var merged: [HomeExperimentItem] = []
                        merged.reserveCapacity(experimentDocs.count)

                        for doc in experimentDocs {
                            let expId = doc.documentID
                            let data = doc.data()

                            let title = data["title"] as? String ?? "Untitled"

                            let progressInfo = progressById[expId]
                            var status = progressInfo?.status ?? "Locked"
                            let progress = progressInfo?.progress ?? 0.0

                            if title == "Ammonia Process" {
                                status = "Completed"
                            } else if title == "Methanol Synthesis" {
                                status = "In Progress"
                            } else if title == "Ostwald Process" {
                                status = "Locked"
                            }

                            let iconName = "flame.fill"

                            var experimentModel: Experiment? = nil
                            if status != "Locked" {
                                let testExperiment = data["testExperiment"] as? String ?? ""
                                let setup = data["setup"] as? [String] ?? []
                                let build = data["build"] as? [String] ?? []
                                let theory = data["theory"] as? String ?? ""
                                let test = data["test"] as? String ?? ""
                                let results = data["results"] as? String ?? ""
                                let model = data["model"] as? String ?? ""

                                experimentModel = Experiment(
                                    title: title,
                                    testExperiment: testExperiment,
                                    setup: setup,
                                    build: build,
                                    theory: theory,
                                    test: test,
                                    results: results,
                                    model: model
                                )
                            }

                            let item = HomeExperimentItem(
                                id: expId,
                                title: title,
                                status: status,
                                progress: progress,
                                experiment: experimentModel,
                                iconName: iconName
                            )
                            merged.append(item)
                        }

                        self.applyHomeLogic(items: merged)
                    })
            }
    }

    private func applyHomeLogic(items: [HomeExperimentItem]) {
        // Continue item: Find the furthest "In Progress" experiment sequentially 
        var inProgress: HomeExperimentItem?
        for item in items.reversed() {
            if item.status == "In Progress" {
                inProgress = item
                break
            }
        }

        if inProgress != nil {
            continueItem = inProgress
        } else {
            // Find the furthest unlocked item if nothing is actively in progress
            var latestUnlocked: HomeExperimentItem?
            for item in items.reversed() {
                if item.status != "Locked" {
                    latestUnlocked = item
                    break
                }
            }
            continueItem = latestUnlocked
        }

        // Locked items: show up to 3 locked experiments
        var locked: [HomeExperimentItem] = []
        for item in items {
            if item.status == "Locked" {
                locked.append(item)
                if locked.count == 3 { break }
            }
        }
        lockedItems = locked

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table Setup
extension HomeScreenNativeViewController: UITableViewDelegate, UITableViewDataSource {

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.register(GreetingCell.self, forCellReuseIdentifier: GreetingCell.identifier)
        tableView.register(StreakTableViewCell.self, forCellReuseIdentifier: "StreakCell")
        tableView.register(CalendarWidgetCell.self, forCellReuseIdentifier: CalendarWidgetCell.identifier)
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else { return 0 }

        switch sec {
        case .greeting: return 1
        case .streak: return 1
        case .continueLearning:
            return (continueItem == nil) ? 0 : 1
        case .calendar: return 1
        case .moreToLearn:
            return lockedItems.count
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sec = Section(rawValue: section) else { return nil }

        // Only show headers for sections that have content
        if sec == .continueLearning, continueItem == nil { return nil }
        if sec == .moreToLearn, lockedItems.isEmpty { return nil }

        if sec != .continueLearning && sec != .moreToLearn { return nil }

        let headerView = UIView()
        headerView.backgroundColor = .clear

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if sec == .continueLearning { label.text = "Continue Learning" }
        else if sec == .moreToLearn { label.text = "More to Learn" }
        
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
        guard let sec = Section(rawValue: section) else { return 0 }

        if sec == .continueLearning, continueItem == nil { return 0 }
        if sec == .moreToLearn, lockedItems.isEmpty { return 0 }

        if sec == .continueLearning || sec == .moreToLearn { return 50 }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sec = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        switch sec {
        case .greeting:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GreetingCell.identifier, for: indexPath) as? GreetingCell else {
                return UITableViewCell()
            }
            let name = UserManager.shared.currentUser?.name ?? "Chemist"
            cell.configure(name: name)
            return cell

        case .streak:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StreakCell", for: indexPath) as? StreakTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(days: 12)
            return cell
            
        case .calendar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarWidgetCell.identifier, for: indexPath) as? CalendarWidgetCell else {
                return UITableViewCell()
            }
            cell.configure(streak: 12)
            return cell

        case .continueLearning:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LearningCardCell.identifier, for: indexPath) as? LearningCardCell else {
                return UITableViewCell()
            }

            // continueItem is guaranteed to exist since numberOfRows returns 0 otherwise
            let item = continueItem!

            cell.configure(
                title: item.title,
                subtitle: "Resume your last experiment",
                progress: Float(item.progress),
                iconName: item.iconName
            )
            return cell

        case .moreToLearn:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LockedTopicCell.identifier, for: indexPath) as? LockedTopicCell else {
                return UITableViewCell()
            }

            let item = lockedItems[indexPath.row]
            cell.configure(title: item.title, iconName: "lock.fill")
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let sec = Section(rawValue: indexPath.section) else { return }
        
        if sec == .moreToLearn {
            let item = lockedItems[indexPath.row]
            if item.status == "Locked" {
                let alert = UIAlertController(title: "Experiment Locked", message: "Complete previous modules to unlock this one.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
            return
        }
        
        guard sec == .continueLearning else { return }
        
        guard let item = continueItem else { 
            print("No continue item available")
            return 
        }
        
        guard item.status != "Locked", let experiment = item.experiment else { 
            print("Failed to navigate. Item status: \(item.status), experiment is valid: \(item.experiment != nil)")
            return 
        }

        let setUpVC = SetUpViewController(experiment: experiment, nib: "SetUp")
        setUpVC.isAtHome = true
        navigationController?.pushViewController(setUpVC, animated: true)
    }
}

//
// MARK: - Greeting Cell
//
final class GreetingCell: UITableViewCell {

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

        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        greetingLabel.textColor = AppColors.cardPrimary
        contentView.addSubview(greetingLabel)

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
        if hour >= 5 && hour < 12 { return "Good morning" }
        if hour >= 12 && hour < 17 { return "Good afternoon" }
        return "Good evening"
    }
}

// MARK: - Greeting Cell
//
// MARK: - Calendar Widget Cell
final class CalendarWidgetCell: UITableViewCell {
    static let identifier = "CalendarWidgetCell"
    private let cardView = UIView()
    private let monthLabel = UILabel()
    private let gridStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        cardView.backgroundColor = AppColors.cardPrimary
        cardView.layer.cornerRadius = 16
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let currentMonthString = formatter.string(from: Date()).uppercased()
        
        monthLabel.text = currentMonthString
        monthLabel.font = .systemFont(ofSize: 14, weight: .bold)
        monthLabel.textColor = AppColors.textPrimary
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(monthLabel)
        
        gridStack.axis = .vertical
        gridStack.spacing = 10
        gridStack.distribution = .fillEqually
        gridStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(gridStack)
        
        buildGrid()
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            monthLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            monthLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            gridStack.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 16),
            gridStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            gridStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            gridStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            gridStack.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var trackedStreak: Int = 0
    
    func configure(streak: Int) {
        self.trackedStreak = streak
        for subview in gridStack.arrangedSubviews {
            subview.removeFromSuperview()
        }
        buildGrid()
    }
    
    private func buildGrid() {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let headerRow = UIStackView()
        headerRow.axis = .horizontal
        headerRow.distribution = .fillEqually
        for day in days {
            let lbl = UILabel()
            lbl.text = day
            lbl.font = .systemFont(ofSize: 10, weight: .semibold)
            lbl.textColor = .lightGray
            lbl.textAlignment = .center
            headerRow.addArrangedSubview(lbl)
        }
        gridStack.addArrangedSubview(headerRow)
        
        let targetEndDay = 30
        let streakStartDay = max(1, targetEndDay - trackedStreak + 1)
        
        // Add 5 rows of dates
        var dateCounter = 15
        for _ in 0..<5 {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            for _ in 0..<7 {
                let circleView = UIView()
                // Color dots matching backwards from the 30th matching streak size
                let isCompleted = dateCounter >= streakStartDay && dateCounter <= targetEndDay
                let isCurrentMonth = dateCounter <= 31
                
                let dayContainer = UIView()
                circleView.translatesAutoresizingMaskIntoConstraints = false
                circleView.layer.cornerRadius = 13
                circleView.layer.borderWidth = (isCompleted || !isCurrentMonth) ? 0 : 1
                circleView.layer.borderColor = UIColor.lightGray.cgColor
                circleView.backgroundColor = isCompleted ? AppColors.completed : .clear
                
                let dayLabel = UILabel()
                if isCurrentMonth {
                    dayLabel.text = "\(dateCounter)"
                } else {
                    dayLabel.text = "\(dateCounter - 31)"
                }
                dateCounter += 1
                
                dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
                dayLabel.textColor = isCompleted ? .white : AppColors.textPrimary
                dayLabel.textAlignment = .center
                dayLabel.translatesAutoresizingMaskIntoConstraints = false
                
                dayContainer.addSubview(circleView)
                circleView.addSubview(dayLabel)
                
                NSLayoutConstraint.activate([
                    circleView.centerXAnchor.constraint(equalTo: dayContainer.centerXAnchor),
                    circleView.centerYAnchor.constraint(equalTo: dayContainer.centerYAnchor),
                    circleView.widthAnchor.constraint(equalToConstant: 26),
                    circleView.heightAnchor.constraint(equalToConstant: 26),
                    dayLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
                    dayLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
                ])
                row.addArrangedSubview(dayContainer)
            }
            gridStack.addArrangedSubview(row)
        }
    }
}

//
// MARK: - Learning Card Cell
//
final class LearningCardCell: UITableViewCell {

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

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        progressView.progress = 0
        progressLabel.text = nil
        iconImageView.image = nil
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = AppColors.cardPrimary
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.12
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        contentView.addSubview(containerView)

        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.layer.cornerRadius = 14
        iconContainerView.clipsToBounds = true
        containerView.addSubview(iconContainerView)

        let gradient = CAGradientLayer()
        gradient.colors = [AppColors.progress.cgColor, AppColors.inProgress.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 14
        iconContainerView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconContainerView.addSubview(iconImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = AppColors.textPrimary
        containerView.addSubview(titleLabel)

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = AppColors.inProgress
        containerView.addSubview(subtitleLabel)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = AppColors.progressTrack
        progressView.progressTintColor = AppColors.progress
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        containerView.addSubview(progressView)

        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        progressLabel.textColor = AppColors.progress
        containerView.addSubview(progressLabel)

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

//
// MARK: - Locked Topic Cell
//
final class LockedTopicCell: UITableViewCell {

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

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = AppColors.cardSecondary.withAlphaComponent(0.4)
        containerView.layer.cornerRadius = 14
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = AppColors.locked.withAlphaComponent(0.3).cgColor
        contentView.addSubview(containerView)

        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = AppColors.locked.withAlphaComponent(0.2)
        iconContainerView.layer.cornerRadius = 12
        containerView.addSubview(iconContainerView)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = AppColors.locked
        iconContainerView.addSubview(iconImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = AppColors.locked
        containerView.addSubview(titleLabel)

        lockBadge.translatesAutoresizingMaskIntoConstraints = false
        lockBadge.backgroundColor = AppColors.locked.withAlphaComponent(0.2)
        lockBadge.layer.cornerRadius = 12
        containerView.addSubview(lockBadge)

        lockIcon.translatesAutoresizingMaskIntoConstraints = false
        lockIcon.image = UIImage(systemName: "lock.fill")
        lockIcon.tintColor = AppColors.locked
        lockIcon.contentMode = .scaleAspectFit
        lockBadge.addSubview(lockIcon)

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
