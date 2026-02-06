import UIKit

class GasPrepNewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Data

    let ammoniaExperiment = Experiment(
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

    let ostwaldExperiment = Experiment(
        title: "Ostwald Process",
        testExperiment: "Sulfuric Acid",
        Setup: [
            "Ensure the industrial setup is clean, corrosion-resistant, and well-ventilated. Since the process involves toxic nitrogen oxides at high temperature, operators must wear protective gear and ensure proper gas handling systems are active.",
            "The process is similar to controlled combustion in a car engine, where fuel reacts with oxygen at high temperature to produce useful energy."
        ],
        Build: [
            "The setup includes an ammonia-air mixer, a platinum–rhodium gauze catalyst chamber, heat exchangers to recover heat, oxidation chambers, absorption towers, and cooling systems to convert nitrogen oxides into nitric acid."
        ],
        Theory: "The Ostwald process produces nitric acid by catalytic oxidation of ammonia.",
        Test:
        """
        4NH₃ + 5O₂ → 4NO + 6H₂O
        2NO + O₂ → 2NO₂
        3NO₂ + H₂O → 2HNO₃ + NO
        """,
        Results: "This experiment explains how ammonia is converted into nitric acid on an industrial scale.",
        model: "ostwald"
    )

    // MARK: - Experiment Item Model
    
    struct ExperimentItem {
        let title: String
        let time: String
        let status: String
        let experiment: Experiment?
    }
    
    // MARK: - All Experiments Data
    
    private lazy var allExperiments: [ExperimentItem] = [
        ExperimentItem(title: "Haber Bosch Process", time: "20 mins", status: "In Progress", experiment: ammoniaExperiment),
        ExperimentItem(title: "Ostwald Process", time: "25 mins", status: "Completed", experiment: ostwaldExperiment),
        ExperimentItem(title: "Nitric Acid Preparation", time: "20 mins", status: "Locked", experiment: nil),
        ExperimentItem(title: "Sulfuric Acid Process", time: "20 mins", status: "Locked", experiment: nil)
    ]
    
    // MARK: - Filtered Experiments
    
    private var filteredExperiments: [ExperimentItem] = []

    // MARK: - UI Elements

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back, Scientist"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let continueCard = UIView()
    private let progressView = UIProgressView(progressViewStyle: .default)

    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["All", "Completed", "In Progress"])
        sc.selectedSegmentIndex = 0
        return sc
    }()

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Empty State Label
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No experiments found"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppColors.textPrimary.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.background
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false

        setupContinueCard()
        setupSegmentControl()
        setupTableView()
        layoutUI()
        
        // Initial filter
        filterExperiments()
    }

    // MARK: - Continue Card

    private func setupContinueCard() {
        continueCard.backgroundColor = AppColors.cardPrimary
        continueCard.layer.cornerRadius = 20
        continueCard.layer.shadowColor = UIColor.black.cgColor
        continueCard.layer.shadowOpacity = 0.25
        continueCard.layer.shadowRadius = 12
        continueCard.layer.shadowOffset = CGSize(width: 0, height: 6)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openHaber))
        continueCard.addGestureRecognizer(tapGesture)

        let title = UILabel()
        title.text = "Continue Understanding"
        title.font = .systemFont(ofSize: 16, weight: .medium)
        title.textColor = AppColors.textPrimary.withAlphaComponent(0.7)
        title.translatesAutoresizingMaskIntoConstraints = false

        let subtitle = UILabel()
        subtitle.text = "Gas Preparation"
        subtitle.font = .systemFont(ofSize: 32, weight: .bold)
        subtitle.textColor = AppColors.textPrimary
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        progressView.progress = 0.5
        progressView.progressTintColor = AppColors.progress
        progressView.trackTintColor = AppColors.progressTrack.withAlphaComponent(0.4)
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false

        continueCard.addSubview(title)
        continueCard.addSubview(subtitle)
        continueCard.addSubview(progressView)

        NSLayoutConstraint.activate([
            // Title
            title.topAnchor.constraint(equalTo: continueCard.topAnchor, constant: 15),
            title.leadingAnchor.constraint(equalTo: continueCard.leadingAnchor, constant: 10),

            // Progress View
            progressView.leadingAnchor.constraint(equalTo: continueCard.leadingAnchor, constant: 10),
            progressView.bottomAnchor.constraint(equalTo: continueCard.bottomAnchor, constant: -15),
            progressView.trailingAnchor.constraint(equalTo: continueCard.trailingAnchor, constant: -18),

            // Subtitle
            subtitle.leadingAnchor.constraint(equalTo: continueCard.leadingAnchor, constant: 10),
            subtitle.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -15)
        ])
    }

    // MARK: - Segmented Control

    private func setupSegmentControl() {
        segmentControl.backgroundColor = AppColors.cardSecondary
        segmentControl.selectedSegmentTintColor = AppColors.background
        segmentControl.setTitleTextAttributes([.foregroundColor: AppColors.textPrimary], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        // Add target for segment change
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Segment Control Action
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        filterExperiments()
    }
    
    // MARK: - Filter Logic
    
    // MARK: - Filter Logic

    private func filterExperiments() {
        switch segmentControl.selectedSegmentIndex {
        case 0: // All
            filteredExperiments = allExperiments
        case 1: // Completed
            filteredExperiments = allExperiments.filter({ item in
                return item.status == "Completed"
            })
        case 2: // In Progress
            filteredExperiments = allExperiments.filter({ item in
                return item.status == "In Progress"
            })
        default:
            filteredExperiments = allExperiments
        }
        
        // Update empty state visibility
        emptyStateLabel.isHidden = !filteredExperiments.isEmpty
        tableView.isHidden = filteredExperiments.isEmpty
        
        // Reload table
        tableView.reloadData()
    }

    // MARK: - Table

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExperimentCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }

    private func layoutUI() {
        let mainStack = UIStackView(arrangedSubviews: [
            welcomeLabel,
            continueCard,
            segmentControl,
            tableView
        ])

        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty state label centered in table view area
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])

        continueCard.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }

    // MARK: - Table Data

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExperiments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 80 }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let experimentItem = filteredExperiments[indexPath.row]
        
        // Only allow navigation for unlocked experiments
        guard experimentItem.status != "Locked" else {
            // Optionally show an alert that the experiment is locked
            showLockedAlert()
            return
        }
        
        if let experiment = experimentItem.experiment {
            let vc = SetUpViewController(experiment: experiment, nib: "SetUp")
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExperimentCell
        cell.selectionStyle = .none

        let experimentItem = filteredExperiments[indexPath.row]
        cell.configure(title: experimentItem.title, time: experimentItem.time, status: experimentItem.status)

        return cell
    }
    
    // MARK: - Locked Alert
    
    private func showLockedAlert() {
        let alert = UIAlertController(
            title: "Experiment Locked",
            message: "Complete the previous experiments to unlock this one.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Navigation

    @objc private func openHaber() {
        let vc = SetUpViewController(experiment: ammoniaExperiment, nib: "SetUp")
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openOstwald() {
        let vc = SetUpViewController(experiment: ostwaldExperiment, nib: "SetUp")
        navigationController?.pushViewController(vc, animated: true)
    }
}
