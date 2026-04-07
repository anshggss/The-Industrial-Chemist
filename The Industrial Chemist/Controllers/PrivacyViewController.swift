import UIKit

class PrivacyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let sections: [(header: String, items: [(title: String, subtitle: String)])] = [
        ("DATA USAGE", [
            ("Analytics", "Allow usage data collection to improve the app"),
            ("Personalised content", "Use your activity to personalise your learning experience"),
            ("Marketing emails", "Receive updates, tips, and promotional emails")
        ]),
        ("PERMISSIONS", [
            ("Location features", "Allow use of location for region-specific content"),
            ("Camera access", "Required for AR experiment features")
        ]),
        ("YOUR DATA", [
            ("Download your data", "Request a copy of all data we hold about you"),
            ("Delete your data", "Request permanent deletion of your personal data")
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 24/255, green: 4/255, blue: 46/255, alpha: 1)
        title = "Privacy settings"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    private func setupTable() {
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
    }

    func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].header
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = .gray
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = sections[indexPath.section].items[indexPath.row]
        let isDataSection = indexPath.section == 2

        let attributed = NSMutableAttributedString(
            string: item.title + "\n",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]
        )
        attributed.append(NSAttributedString(
            string: item.subtitle,
            attributes: [.font: UIFont.systemFont(ofSize: 13),
                         .foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        ))

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = attributed
        cell.backgroundColor = .clear

        if isDataSection {
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = nil
            cell.selectionStyle = .default
            cell.textLabel?.textColor = .systemBlue
        } else {
            let toggle = UISwitch()
            toggle.onTintColor = .systemBlue
            toggle.isOn = true
            cell.accessoryView = toggle
            cell.selectionStyle = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 2 else { return }

        let item = sections[indexPath.section].items[indexPath.row]
        let alert = UIAlertController(
            title: item.title,
            message: "This feature is coming soon.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
