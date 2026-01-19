import UIKit

class PrivacyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let items = [
        ("Information collection", "Allow information collection for analytics"),
        ("Share speech", "Anonymously share speech to help improve"),
        ("Location Features", "Allow use of location for features")
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]

        let title = NSMutableAttributedString(
            string: item.0 + "\n",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]
        )

        title.append(NSAttributedString(
            string: item.1,
            attributes: [.font: UIFont.systemFont(ofSize: 13),
                         .foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        ))

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = title
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        let toggle = UISwitch()
        toggle.onTintColor = .systemBlue
        toggle.isOn = true
        cell.accessoryView = toggle

        return cell
    }
}
