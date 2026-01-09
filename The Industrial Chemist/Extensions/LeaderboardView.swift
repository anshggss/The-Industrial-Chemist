import UIKit

class LeaderboardView: UIView {

    // MARK: - Header Outlets

    @IBOutlet weak var daysImageView: UIImageView!
    @IBOutlet weak var daysLabel: UILabel!

    @IBOutlet weak var xpImageView: UIImageView!
    @IBOutlet weak var xpLabel: UILabel!

    @IBOutlet weak var rankImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!

    // Card containers (UIViews inside horizontal stack views)
    @IBOutlet weak var xpContainer: UIView!
    @IBOutlet weak var daysContainer: UIView!

    // Table
    @IBOutlet weak var tableView: UITableView!

    // Data
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

    // MARK: - XIB Loader

    private func loadFromXib() {
        let contentView = Bundle.main.loadNibNamed(
            "LeaderboardView",
            owner: self,
            options: nil
        )?.first as! UIView

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)

        applyTheme()
        setupHeader()
        setupTableView()
        loadDummyData()
    }

    // MARK: - Theme

    private func applyTheme() {
        // Page background
        backgroundColor = AppColors.background

        // Cards
        styleCard(xpContainer)
        styleCard(daysContainer)

        // Labels
        daysLabel.textColor = AppColors.textPrimary
        xpLabel.textColor = AppColors.textPrimary
        rankLabel.textColor = UIColor(hex: "#D6B4FF")



        daysLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        xpLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        rankLabel.font = .systemFont(ofSize: 22, weight: .bold)

        // Icons
        daysImageView.tintColor = AppColors.icon
        xpImageView.tintColor = AppColors.icon
        rankImageView.tintColor = AppColors.icon

        // 🔒 Prevent labels from collapsing (CRITICAL FIX)
        xpLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        xpLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        daysLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        daysLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private func styleCard(_ view: UIView) {
        view.backgroundColor = AppColors.cardPrimary
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = false

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    // MARK: - Header Content

    private func setupHeader() {
        daysLabel.text = "7 Days"
        xpLabel.text = "1240 XP"
        rankLabel.text = "#12"
        xpImageView.image = UIImage(systemName: "bolt.fill")
    }

    // MARK: - Table Setup

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)

        tableView.register(
            UINib(nibName: "LeaderboardCell", bundle: nil),
            forCellReuseIdentifier: "LeaderboardCell"
        )
    }

    // MARK: - Dummy Data

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

// MARK: - Table Delegate & DataSource

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
        72
    }

}
