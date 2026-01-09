import UIKit

class LeaderboardView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var daysImageView: UIImageView!
    @IBOutlet weak var daysLabel: UILabel!

    @IBOutlet weak var xpImageView: UIImageView!
    @IBOutlet weak var xpLabel: UILabel!

    @IBOutlet weak var rankImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    private var leaderboardData: [LeaderboardEntry] = []

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXib()
    }

    private func loadFromXib() {
        let view = Bundle.main.loadNibNamed(
            "LeaderboardView",
            owner: self,
            options: nil
        )?.first as! UIView

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)

        setupTableView()
        loadDummyData()
        setupHeader()
    }

    // MARK: - Setup

    private func setupHeader() {
        daysLabel.text = "7 Days"
        xpLabel.text = "1240 XP"
        rankLabel.text = "#12"
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        tableView.register(
            UINib(nibName: "LeaderboardCell", bundle: nil),
            forCellReuseIdentifier: "LeaderboardCell"
        )
    }

    private func loadDummyData() {
        leaderboardData = [
            LeaderboardEntry(rank: 1, name: "Alex", xp: 5400, profileImage: UIImage(systemName: "person.circle.fill")),
            LeaderboardEntry(rank: 2, name: "Riya", xp: 5100, profileImage: UIImage(systemName: "person.circle.fill")),
            LeaderboardEntry(rank: 3, name: "Kabir", xp: 4800, profileImage: UIImage(systemName: "person.circle.fill")),
            LeaderboardEntry(rank: 4, name: "Ansh", xp: 4500, profileImage: UIImage(systemName: "person.circle.fill")),
            LeaderboardEntry(rank: 5, name: "Meera", xp: 4200, profileImage: UIImage(systemName: "person.circle.fill"))
        ]
        tableView.reloadData()
    }
}

extension LeaderboardView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        leaderboardData.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "LeaderboardCell",
            for: indexPath
        ) as! LeaderboardCell

        cell.configure(with: leaderboardData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
}
