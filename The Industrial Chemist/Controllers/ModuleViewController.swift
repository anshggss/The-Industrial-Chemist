import FirebaseFirestore
import FirebaseAuth

class ModuleViewController: UIViewController {

    private let db = Firestore.firestore()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    private var gasPrepProgress: Float = 0.0
    private var gasPrepCount: Int = 0 
    private var gasPrepCompleted: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Refresh on completion
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchModuleData),
            name: ResultsViewController.experimentCompletedNotification,
            object: nil
        )

        // Observe global stats updates (XP, level, etc.)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchModuleData),
            name: ExperienceManager.statsUpdatedNotification,
            object: nil
        )
        
        fetchModuleData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchModuleData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = "Modules"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white

        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    @objc private func fetchModuleData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("experiments").getDocuments { [weak self] expSnapshot, _ in
            guard let self = self else { return }
            let allExperiments = expSnapshot?.documents ?? []
            
            self.db.collection("users").document(uid).collection("progress").getDocuments { [weak self] progSnapshot, _ in
                guard let self = self else { return }
                let progressDocs = progSnapshot?.documents ?? []
                var progressMap: [String: Double] = [:]
                for doc in progressDocs {
                    progressMap[doc.documentID] = doc.data()["progress"] as? Double ?? 0.0
                }
                
                // Calculate Gas Prep progress
                // Since there is no module field yet, we assume all current experiments are Gas Prep
                // except if they are acid-base
                var gpTotal: Double = 0
                var gpCount = 0
                var gpMax: Double = 0
                
                for exp in allExperiments {
                    let title = exp.data()["title"] as? String ?? ""
                    if !title.lowercased().contains("acid") {
                        gpCount += 1
                        let prog = progressMap[exp.documentID] ?? 0.0
                        gpTotal += prog
                        if prog > gpMax { gpMax = prog }
                    }
                }
                
                // User Request: Home = 50% (avg), Module Page = 100% (max/specific completion)
                self.updateUI(gasPrepProgress: Float(gpMax))
            }
        }
    }

    private func updateUI(gasPrepProgress: Float) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Continue your learning journey"
        subtitleLabel.textColor = .lightGray
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        stackView.addArrangedSubview(subtitleLabel)

        let gasPrepSubtitle = gasPrepProgress >= 1.0 ? "Module Completed" : "Continue Understanding"
        let gasPrepCard = createModuleCard(
            title: "Gas Preparation", 
            subtitle: gasPrepSubtitle, 
            progressText: "\(Int(gasPrepProgress * 100))%", 
            progressValue: gasPrepProgress, 
            isLocked: false, 
            action: #selector(gasPrepTapped)
        )
        stackView.addArrangedSubview(gasPrepCard)

        let upNextLabel = UILabel()
        upNextLabel.text = "Up Next"
        upNextLabel.textColor = .white
        upNextLabel.font = .systemFont(ofSize: 22, weight: .bold)
        stackView.addArrangedSubview(upNextLabel)
        stackView.setCustomSpacing(12, after: upNextLabel)

        let acidBaseCard = createModuleCard(
            title: "Acid Base Preparation", 
            subtitle: "Start Learning", 
            progressText: "0%", 
            progressValue: 0.0, 
            isLocked: true, 
            action: #selector(acidBaseTapped)
        )
        stackView.addArrangedSubview(acidBaseCard)
    }

    private func createModuleCard(title: String, subtitle: String, progressText: String, progressValue: Float, isLocked: Bool, action: Selector) -> UIView {
        let card = UIView()
        card.layer.cornerRadius = 20
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.2
        card.layer.shadowRadius = 10
        card.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        card.backgroundColor = isLocked ? UIColor(white: 0.2, alpha: 1) : AppColors.cardPrimary
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = isLocked ? .white : AppColors.textPrimary
        
        let subLabel = UILabel()
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.text = subtitle
        subLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subLabel.textColor = isLocked ? .lightGray : AppColors.textPrimary.withAlphaComponent(0.7)
        
        let playImageView = UIImageView(image: UIImage(systemName: isLocked ? "lock.fill" : "play.fill"))
        playImageView.translatesAutoresizingMaskIntoConstraints = false
        playImageView.tintColor = isLocked ? .lightGray : AppColors.textPrimary
        playImageView.contentMode = .scaleAspectFit
        
        let progressTitle = UILabel()
        progressTitle.translatesAutoresizingMaskIntoConstraints = false
        progressTitle.text = isLocked ? "20 mins" : "Progress"
        progressTitle.font = .systemFont(ofSize: 15, weight: .bold)
        progressTitle.textColor = isLocked ? .lightGray : AppColors.textPrimary
        
        let progressPercent = UILabel()
        progressPercent.translatesAutoresizingMaskIntoConstraints = false
        progressPercent.text = progressText
        progressPercent.font = .systemFont(ofSize: 15, weight: .regular)
        progressPercent.textColor = isLocked ? .lightGray : AppColors.textPrimary
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = progressValue
        progressView.progressTintColor = isLocked ? .gray : AppColors.progress
        progressView.trackTintColor = isLocked ? .lightGray : AppColors.progressTrack.withAlphaComponent(0.4)
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: action)
        card.addGestureRecognizer(tap)
        card.isUserInteractionEnabled = true
        
        card.addSubview(titleLabel)
        card.addSubview(subLabel)
        card.addSubview(playImageView)
        card.addSubview(progressTitle)
        card.addSubview(progressPercent)
        card.addSubview(progressView)

        let timerIcon = UIImageView(image: UIImage(systemName: "timer"))
        timerIcon.translatesAutoresizingMaskIntoConstraints = false
        timerIcon.tintColor = .darkGray
        timerIcon.isHidden = !isLocked
        card.addSubview(timerIcon)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 160),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: playImageView.leadingAnchor, constant: -10),
            
            playImageView.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            playImageView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            playImageView.widthAnchor.constraint(equalToConstant: 30),
            playImageView.heightAnchor.constraint(equalToConstant: 30),
            
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            progressView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            progressView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            progressPercent.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -12),
            progressPercent.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            
            progressTitle.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -12),
        ])

        if isLocked {
            NSLayoutConstraint.activate([
                timerIcon.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
                timerIcon.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -12),
                timerIcon.widthAnchor.constraint(equalToConstant: 18),
                timerIcon.heightAnchor.constraint(equalToConstant: 18),
                
                progressTitle.leadingAnchor.constraint(equalTo: timerIcon.trailingAnchor, constant: 6)
            ])
        } else {
            NSLayoutConstraint.activate([
                progressTitle.leadingAnchor.constraint(equalTo: progressView.leadingAnchor)
            ])
        }
        
        return card
    }

    @objc private func gasPrepTapped() {
        let vc = GasPrepNewViewController(nibName: "GasPrepNew", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func acidBaseTapped() {
        let alert = UIAlertController(title: "Module Locked", message: "Complete previous modules to unlock this one.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
