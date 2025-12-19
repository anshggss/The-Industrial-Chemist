import UIKit

class ComponentsTableViewController: UITableViewController {

    private let data: [(title: String, subtitle: String)] = [
        ("Reactors", "High-pressure chemical reactions"),
        ("Distillation columns", "Precise mixture separation"),
        ("Heat exchangers", "Critical temperature control"),
        ("Mixers & agitators", "Blending raw materials")
    ]

    private var tableHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()

        tableView.contentInset = .zero
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }

        // 🔹 constrain TABLE VIEW, not VC view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 1)
        tableHeightConstraint?.priority = .required
        tableHeightConstraint?.isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeightConstraint?.constant = tableView.contentSize.height
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let item = data[indexPath.row]

        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .detailButton

        return cell
    }
}
