import UIKit

class LeaderboardCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        backgroundColor = .clear

        contentView.backgroundColor = AppColors.cardPrimary
        contentView.layer.masksToBounds = true

        rankLabel.textColor = AppColors.textPrimary
        nameLabel.textColor = AppColors.textPrimary
        xpLabel.textColor = AppColors.textPrimary

        rankLabel.font = .systemFont(ofSize: 14, weight: .bold)
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        xpLabel.font = .systemFont(ofSize: 14, weight: .medium)

        profileImageView.tintColor = AppColors.icon
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        
        contentView.layoutMargins = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)

    }

    func configure(with entry: LeaderboardEntry) {
        rankLabel.text = "\(entry.rank)"
        nameLabel.text = entry.name
        xpLabel.text = "\(entry.xp) XP"
        profileImageView.image = entry.profileImage
    }
}
