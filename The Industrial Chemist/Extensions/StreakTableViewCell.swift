import UIKit

class StreakTableViewCell: UITableViewCell {

    private let glassContainer = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let gradientLayer = CAGradientLayer()
    private let flameImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        animateLiquid()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        animateLiquid()
    }

    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Container
        glassContainer.translatesAutoresizingMaskIntoConstraints = false
        glassContainer.layer.cornerRadius = 24
        glassContainer.layer.shadowColor = UIColor.black.cgColor
        glassContainer.layer.shadowOpacity = 0.2
        glassContainer.layer.shadowRadius = 16
        glassContainer.layer.shadowOffset = CGSize(width: 0, height: 8)
        contentView.addSubview(glassContainer)

        NSLayoutConstraint.activate([
            glassContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            glassContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            glassContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            glassContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        // Blur + gradient
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 24
        blurView.clipsToBounds = true
        glassContainer.addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: glassContainer.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: glassContainer.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: glassContainer.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: glassContainer.trailingAnchor)
        ])

        // Gradient overlay
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.08).cgColor,
            UIColor.white.withAlphaComponent(0.02).cgColor,
            UIColor.white.withAlphaComponent(0.08).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 24
        blurView.layer.addSublayer(gradientLayer)

        // Border
        glassContainer.layer.borderWidth = 1
        glassContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor

        // Flame icon
        flameImageView.image = UIImage(systemName: "flame.fill")
        flameImageView.tintColor = AppColors.progress
        flameImageView.contentMode = .scaleAspectFit
        flameImageView.translatesAutoresizingMaskIntoConstraints = false

        // Title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1

        // Subtitle
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        blurView.contentView.addSubview(flameImageView)
        blurView.contentView.addSubview(textStack)

        NSLayoutConstraint.activate([
            flameImageView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 16),
            flameImageView.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
            flameImageView.widthAnchor.constraint(equalToConstant: 30),
            flameImageView.heightAnchor.constraint(equalToConstant: 30),

            textStack.leadingAnchor.constraint(equalTo: flameImageView.trailingAnchor, constant: 14),
            textStack.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -16),
            textStack.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 16),
            textStack.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -16)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = blurView.bounds
    }

    // MARK: - Liquid Animation
    private func animateLiquid() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.5, 1.0]
        animation.toValue = [0.2, 0.7, 1.2]
        animation.duration = 4
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "liquidAnimation")
    }

    // MARK: - Configure
    func configure(days: Int) {
        titleLabel.text = "\(days) Day Streak"
        subtitleLabel.text = "Keep learning every day to grow!"
    }
}
