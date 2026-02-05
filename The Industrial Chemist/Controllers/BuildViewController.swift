import UIKit

class BuildViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    let experiment: Experiment
    var isAtHome: Bool = false
    
    init(experiment: Experiment) {
        self.experiment = experiment
        super.init(nibName: "Build", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView = UIView()
    private let headerLabel = UILabel()
    private let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupUI()
        embedComponentsVC()
    }

    private func setupUI() {
        containerView.backgroundColor = AppColors.cardPrimary.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = AppColors.cardPrimary.withAlphaComponent(0.3).cgColor

        contentStack.axis = .vertical
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        setupHeader()
    }

    private func setupHeader() {
        headerView.backgroundColor = AppColors.progress.withAlphaComponent(0.3)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "gearshape.2.fill")
        iconView.tintColor = AppColors.cardPrimary
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.text = "COMPONENTS & PROCESSES"
        headerLabel.font = .boldSystemFont(ofSize: 18)
        headerLabel.textColor = AppColors.cardPrimary
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(iconView)
        headerView.addSubview(headerLabel)
        contentStack.addArrangedSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 60),

            iconView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            headerLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }

    private func embedComponentsVC() {
        let componentsVC = ComponentsTableViewController(experiment: experiment)  // ✅ Now works

        addChild(componentsVC)
        contentStack.addArrangedSubview(componentsVC.view)

        componentsVC.view.translatesAutoresizingMaskIntoConstraints = false
        componentsVC.didMove(toParent: self)
    }

    @IBAction func proceedPressed(_ sender: UIButton) {
        let testVC = TestViewController(experiment: experiment)
        testVC.isAtHome = isAtHome
        navigationController?.pushViewController(testVC, animated: false)
    }
}
