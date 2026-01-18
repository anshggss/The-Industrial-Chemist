import UIKit

class NotificationSettingsViewController: UIViewController,
                                          UITableViewDelegate,
                                          UITableViewDataSource {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let items: [(String, String)] = [
        ("Reminders", "Daily practice and streak reminders"),
        ("Friends", "Updates on new followers and your friends’ achievements"),
        ("Leaderboards", "Progress updates in your league"),
        ("Announcements", "Updates about new features, promotions, and events"),
        ("Friend Nudges", "Reminders from friends")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 24/255, green: 4/255, blue: 46/255, alpha: 1)

        title = "Notifications"
        navigationController?.navigationBar.tintColor = .white
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
    }

    // MARK: - UITableViewDataSource (REQUIRED)

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17),
            .foregroundColor: UIColor.white
        ]

        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white.withAlphaComponent(0.7)
        ]

        let attributedText = NSMutableAttributedString(
            string: item.0 + "\n",
            attributes: titleAttributes
        )

        attributedText.append(
            NSAttributedString(
                string: item.1,
                attributes: subtitleAttributes
            )
        )

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = attributedText
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none

        return cell
    }
}
