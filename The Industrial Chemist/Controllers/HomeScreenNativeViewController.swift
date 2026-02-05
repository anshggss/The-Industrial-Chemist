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
        tableView.register(StreakTableViewCell.self, forCellReuseIdentifier: "StreakCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
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
        case 0: return 1   // Greeting
        case 1: return 1   // Streak card
        case 2: return 1   // Continue learning
        case 3: return 3   // More to learn
        default: return 0
        }
    }

    // MARK: Section Headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2: return "Continue Learning"
        case 3: return "More to Learn"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = AppColors.cardPrimary
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }

    // MARK: Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // 🔥 Streak Card
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StreakCell", for: indexPath) as! StreakTableViewCell
            cell.configure(days: 5)
            return cell
        }

        var content = UIListContentConfiguration.valueCell()
        let cell = UITableViewCell()
        cell.backgroundColor = AppColors.cardSecondary
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true

        switch indexPath.section {

        case 0:
            let name = UserManager.shared.currentUser?.name ?? "Chemist"
            content.text = "Hello, \(name) 👋"
            content.secondaryText = "Ready to ignite your inner chemist?"
            content.textProperties.font = .systemFont(ofSize: 22, weight: .bold)
            content.textProperties.color = AppColors.textPrimary
            content.secondaryTextProperties.color = AppColors.textPrimary.withAlphaComponent(0.7)
            cell.selectionStyle = .none

        case 2:
            content.text = "The Haber–Bosch Process"
            content.secondaryText = "Resume your last experiment"
            content.textProperties.color = AppColors.textPrimary
            content.secondaryTextProperties.color = AppColors.inProgress
            content.image = UIImage(systemName: "flame.fill")
            content.imageProperties.tintColor = AppColors.progress
            cell.accessoryType = .disclosureIndicator

        case 3:
            let topics = ["Oxygen Preparation", "Hydrogen Preparation", "Chlorine Preparation"]
            content.text = topics[indexPath.row]
            content.secondaryText = "Coming Soon"
            content.textProperties.color = AppColors.locked
            content.secondaryTextProperties.color = AppColors.locked
            content.image = UIImage(systemName: "lock.fill")
            content.imageProperties.tintColor = AppColors.locked
            cell.selectionStyle = .none
            cell.contentView.alpha = 0.6

        default: break
        }

        cell.contentConfiguration = content
        return cell
    }

    // MARK: Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }

        let setUpVC = SetUpViewController(experiment: experiment, nib: "SetUp")
        setUpVC.isAtHome.toggle()

        let navController = UINavigationController(rootViewController: setUpVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}
