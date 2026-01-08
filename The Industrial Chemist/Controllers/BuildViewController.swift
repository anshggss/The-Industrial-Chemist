import UIKit

class BuildViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!

    private let headerView = UIView()
    private let headerLabel = UILabel()
    private let contentStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        embedComponentsVC()
    }

    private func setupUI() {

        // Rounded corners for output container
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true

        // Stack View setup
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
        headerView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.8)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.text = "COMPONENTS & PROCESSES"
        headerLabel.font = .boldSystemFont(ofSize: 18)
        headerLabel.textColor = .white
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(headerLabel)
        contentStack.addArrangedSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 90),

            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }

    private func embedComponentsVC() {
        let componentsVC = ComponentsTableViewController()

        addChild(componentsVC)
        contentStack.addArrangedSubview(componentsVC.view)

        componentsVC.view.translatesAutoresizingMaskIntoConstraints = false
        componentsVC.didMove(toParent: self)
    }

    @IBAction func proceedPressed(_ sender: UIButton) {
        let testVC = TestViewController(nibName: "Test", bundle: nil)
        navigationController?.pushViewController(testVC, animated: false)
    }
}
