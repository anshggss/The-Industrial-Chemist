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
        configureView()
        configureTableView()
    }

    // MARK: - View Configuration

    private func configureView() {
        view.backgroundColor = UIColor(red: 24/255, green: 4/255, blue: 46/255, alpha: 1)

        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.15)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = actionFooter()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Footer

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

// MARK: - Table Delegate & Data Source

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { 4 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return accountItems.count
        case 1: return subscriptionItems.count
        case 2: return supportItems.count
        case 3: return legalItems.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
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
        (view as? UITableViewHeaderFooterView)?
            .textLabel?.textColor = .gray
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
        cell.textLabel?.textColor = isLegal ? .systemBlue : .white
        cell.accessoryType = isLegal ? .none : .disclosureIndicator

        return cell
    }

    // MARK: - Modal Routing (Account Section)

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard indexPath.section == 0 else { return }

        let vc: UIViewController?

        switch indexPath.row {

        case 0:
            vc = PreferencesViewController(nibName: "Preferences", bundle: nil)

        case 1:
            vc = ProfileSettingsViewController(nibName: "ProfileSettings", bundle: nil)

        case 2:
            vc = NotificationsViewController(nibName: "Notifications", bundle: nil)

        case 3:
            // COURSES — intentionally no action (no VC exists yet)
            vc = nil

        case 4:
            vc = CFSViewController(nibName: "CFS", bundle: nil)

        case 5:
            vc = SocialSettingsViewController(nibName: "SocialSettings", bundle: nil)

        case 6:
            vc = PrivacyViewController(nibName: "Privacy", bundle: nil)

        default:
            vc = nil
        }

        guard let controller = vc else { return }

        controller.modalPresentationStyle = .automatic
        controller.modalTransitionStyle = .coverVertical

        present(controller, animated: true)
    }

}
