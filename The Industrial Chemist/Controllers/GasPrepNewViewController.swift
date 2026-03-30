import UIKit
import FirebaseAuth
import FirebaseFirestore

final class GasPrepNewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Firebase
    private let db = Firestore.firestore()

    // MARK: - Experiment Item Model (table rows)
    struct ExperimentItem {
        let id: String
        let title: String
        let time: String
        let status: String            // "Locked" / "In Progress" / "Completed"
        let experiment: Experiment?   // nil if locked
        let progress: Double          // 0...1
    }

    // MARK: - Data
    private var allExperiments: [ExperimentItem] = []
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

    private let tableView = UITableView(frame: .zero, style: .plain)

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

        fetchExperimentsAndProgress()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExperimentsAndProgress()
    }

    // MARK: - Firestore Fetch
    private func fetchExperimentsAndProgress() {
        guard let uid = Auth.auth().currentUser?.uid else {
            allExperiments = []
            filterExperiments()
            return
        }

        db.collection("experiments")
            .order(by: "order")
            .getDocuments(completion: { [weak self] expSnapshot, expError in
                guard let self = self else { return }

                if let expError = expError {
                    print("Experiments fetch error: \(expError)")
                    return
                }

                let experimentDocs = expSnapshot?.documents ?? []

                self.db.collection("users")
                    .document(uid)
                    .collection("progress")
                    .getDocuments(completion: { [weak self] progSnapshot, progError in
                        guard let self = self else { return }

                        if let progError = progError {
                            print("Progress fetch error: \(progError)")
                            return
                        }

                        var progressByExperimentId: [String: (status: String, progress: Double)] = [:]
                        let progressDocs = progSnapshot?.documents ?? []

                        for progressDoc in progressDocs {
                            let data = progressDoc.data()
                            let status = data["status"] as? String ?? "Locked"
                            let progress = data["progress"] as? Double ?? 0.0
                            progressByExperimentId[progressDoc.documentID] = (status: status, progress: progress)
                        }

                        var merged: [ExperimentItem] = []
                        merged.reserveCapacity(experimentDocs.count)

                        for expDoc in experimentDocs {
                            let expId = expDoc.documentID
                            let data = expDoc.data()

                            let title = data["title"] as? String ?? "Untitled"
                            let time = data["time"] as? String ?? ""

                            let progressInfo = progressByExperimentId[expId]
                            var status = progressInfo?.status ?? "Locked"
                            let progValue = progressInfo?.progress ?? 0.0

                            if title == "Ammonia Process" {
                                status = "Completed"
                            } else if title == "Methanol Synthesis" {
                                status = "In Progress"
                            } else if title == "Ostwald Process" {
                                status = "Locked"
                            }

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

                            merged.append(
                                ExperimentItem(
                                    id: expId,
                                    title: title,
                                    time: time,
                                    status: status,
                                    experiment: experimentModel,
                                    progress: progValue
                                )
                            )
                        }

                        self.allExperiments = merged
                        self.updateContinueCard()
                        self.filterExperiments()
                    })
            })
    }

    private func updateContinueCard() {
        var inProgressItem: ExperimentItem? = nil
        for item in allExperiments {
            if item.status == "In Progress" {
                inProgressItem = item
                break
            }
        }
        progressView.progress = Float(inProgressItem?.progress ?? 0.0)
    }

    // MARK: - Continue Card
    private func setupContinueCard() {
        continueCard.backgroundColor = AppColors.cardPrimary
        continueCard.layer.cornerRadius = 20
        continueCard.layer.shadowColor = UIColor.black.cgColor
        continueCard.layer.shadowOpacity = 0.25
        continueCard.layer.shadowRadius = 12
        continueCard.layer.shadowOffset = CGSize(width: 0, height: 6)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openContinue))
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

        progressView.progress = 0.0
        progressView.progressTintColor = AppColors.progress
        progressView.trackTintColor = AppColors.progressTrack.withAlphaComponent(0.4)
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false

        continueCard.addSubview(title)
        continueCard.addSubview(subtitle)
        continueCard.addSubview(progressView)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: continueCard.topAnchor, constant: 15),
            title.leadingAnchor.constraint(equalTo: continueCard.leadingAnchor, constant: 10),

            progressView.leadingAnchor.constraint(equalTo: continueCard.leadingAnchor, constant: 10),
            progressView.bottomAnchor.constraint(equalTo: continueCard.bottomAnchor, constant: -15),
            progressView.trailingAnchor.constraint(equalTo: continueCard.trailingAnchor, constant: -18),

            subtitle.leadingAnchor.constraint(equalTo: continueCard.leadingAnchor, constant: 10),
            subtitle.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -15)
        ])
    }

    @objc private func openContinue() {
        var candidate: ExperimentItem? = nil

        for item in allExperiments {
            if item.status == "In Progress" {
                candidate = item
                break
            }
        }

        if candidate == nil {
            for item in allExperiments {
                if item.status != "Locked" {
                    candidate = item
                    break
                }
            }
        }

        guard let item = candidate else { return }

        guard item.status != "Locked", let experiment = item.experiment else {
            showLockedAlert()
            return
        }

        let vc = SetUpViewController(experiment: experiment, nib: "SetUp")
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Segmented Control
    private func setupSegmentControl() {
        segmentControl.backgroundColor = AppColors.cardSecondary
        segmentControl.selectedSegmentTintColor = AppColors.background
        segmentControl.setTitleTextAttributes([.foregroundColor: AppColors.textPrimary], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        filterExperiments()
    }

    private func filterExperiments() {
        let selectedIndex = segmentControl.selectedSegmentIndex

        if selectedIndex == 0 {
            filteredExperiments = allExperiments
        } else if selectedIndex == 1 {
            var result: [ExperimentItem] = []
            for item in allExperiments {
                if item.status == "Completed" {
                    result.append(item)
                }
            }
            filteredExperiments = result
        } else if selectedIndex == 2 {
            var result: [ExperimentItem] = []
            for item in allExperiments {
                if item.status == "In Progress" {
                    result.append(item)
                }
            }
            filteredExperiments = result
        } else {
            filteredExperiments = allExperiments
        }

        emptyStateLabel.isHidden = !filteredExperiments.isEmpty
        tableView.isHidden = false
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

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])

        continueCard.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }

    // MARK: - UITableViewDataSource/Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExperiments.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredExperiments[indexPath.row]

        guard item.status != "Locked" else {
            showLockedAlert()
            return
        }

        if let experiment = item.experiment {
            let vc = SetUpViewController(experiment: experiment, nib: "SetUp")
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExperimentCell
        cell.selectionStyle = .none

        let item = filteredExperiments[indexPath.row]
        cell.configure(title: item.title, time: item.time, status: item.status)

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
}
