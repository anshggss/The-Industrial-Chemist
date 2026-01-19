import UIKit

class SocialSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let items = [
        ("Facebook", "facebook"),
        ("Google", "google"),
        ("Contacts", "contacts")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 24/255, green: 4/255, blue: 46/255, alpha: 1)
        title = "Social accounts"
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]

        cell.textLabel?.text = item.0
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        let toggle = UISwitch()
        toggle.onTintColor = .systemBlue
        toggle.isOn = indexPath.row != 0   // Facebook OFF like screenshot
        cell.accessoryView = toggle

        return cell
    }
}
