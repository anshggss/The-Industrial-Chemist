import UIKit

class ComponentsTableViewController: UITableViewController {

    private let data: [(title: String, subtitle: String, status: ComponentStatus)] = [
        ("Reactors", "High-pressure chemical reactions", .completed),
        ("Distillation columns", "Precise mixture separation", .active),
        ("Heat exchangers", "Critical temperature control", .pending),
        ("Mixers & agitators", "Blending raw materials", .pending)
    ]
    
    enum ComponentStatus {
        case active
        case completed
        case pending
    }
    
    private let experiment: Experiment?
    private var tableHeightConstraint: NSLayoutConstraint?

    // MARK: - Init
    
    init(experiment: Experiment? = nil) {
        self.experiment = experiment
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        self.experiment = nil
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ComponentCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.contentInset = .zero
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ComponentCell
        let item = data[indexPath.row]
        
        cell.configure(title: item.title, subtitle: item.subtitle, status: item.status)
        
        return cell
    }
}
