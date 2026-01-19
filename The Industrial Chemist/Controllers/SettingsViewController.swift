import UIKit

class SettingsViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let accountItems = [
        "Preferences",
        "Profile",
        "Notifications",
        "Courses",
        "Chemist for Schools",
        "Social accounts",
        "Privacy settings"
    ]

    private let subscriptionItems = [
        "Choose a plan"
    ]

    private let supportItems = [
        "Help Center",
        "Feedback"
    ]

    private let legalItems = [
        "Terms",
        "Privacy Policy",
        "Acknowledgements"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 24/255, green: 4/255, blue: 46/255, alpha: 1)

        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.15)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.tableFooterView = actionFooter()
    }

    private func actionFooter() -> UIView {
        let container = UIView()
        container.frame.size.height = 200

        let restoreButton = makeOutlinedButton(title: "RESTORE SUBSCRIPTION")
        let signOutButton = makeOutlinedButton(title: "SIGN OUT")

        container.addSubview(restoreButton)
        container.addSubview(signOutButton)

        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            restoreButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            restoreButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            restoreButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            restoreButton.heightAnchor.constraint(equalToConstant: 48),

            signOutButton.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 20),
            signOutButton.leadingAnchor.constraint(equalTo: restoreButton.leadingAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: restoreButton.trailingAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        return container
    }

    private func makeOutlinedButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
}

// MARK: - UITableView Delegate & DataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return accountItems.count
        case 1: return subscriptionItems.count
        case 2: return supportItems.count
        case 3: return legalItems.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "ACCOUNT"
        case 1: return "SUBSCRIPTION"
        case 2: return "SUPPORT"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor.gray
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let text: String
        let isLegal = indexPath.section == 3

        switch indexPath.section {
        case 0: text = accountItems[indexPath.row]
        case 1: text = subscriptionItems[indexPath.row]
        case 2: text = supportItems[indexPath.row]
        case 3: text = legalItems[indexPath.row]
        default: text = ""
        }

        cell.textLabel?.text = text
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        if isLegal {
            cell.textLabel?.textColor = .systemBlue
            cell.accessoryType = .none
        } else {
            cell.textLabel?.textColor = .white
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // ACCOUNT → Preferences
        if indexPath.section == 0 && indexPath.row == 0 {
            let vc = PreferencesViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
