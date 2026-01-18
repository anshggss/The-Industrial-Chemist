import UIKit

class PreferencesViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let preferenceItems = [
        "Sound effects",
        "Haptic feedback",
        "Motivational messages",
        "Listening exercises",
        "Friend Streaks"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 32/255, green: 0/255, blue: 60/255, alpha: 1)

        title = "Preferences"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.tintColor = .white
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.15)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toggleCell")

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - TableView Delegate & DataSource
extension PreferencesViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferenceItems.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "LESSON EXPERIENCE"
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "toggleCell", for: indexPath)

        cell.textLabel?.text = preferenceItems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none

        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = UIColor.systemBlue
        cell.accessoryView = toggle

        return cell
    }
}
