import UIKit

class ComponentCell: UITableViewCell {

    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let infoIcon = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.6)
        cardView.layer.cornerRadius = 14
        cardView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white

        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .white.withAlphaComponent(0.8)
        subtitleLabel.numberOfLines = 0

        infoIcon.image = UIImage(systemName: "info.circle")
        infoIcon.tintColor = .white

        [titleLabel, subtitleLabel, infoIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoIcon.leadingAnchor, constant: -8),

            infoIcon.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            infoIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            infoIcon.widthAnchor.constraint(equalToConstant: 20),
            infoIcon.heightAnchor.constraint(equalToConstant: 20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            subtitleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
