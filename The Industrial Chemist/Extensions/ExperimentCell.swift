import UIKit

class ExperimentCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // Icon Container
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 40),
            iconContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            // Icon Image
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusLabel.leadingAnchor, constant: -8),
            
            // Time
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // Status Badge
            statusLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            statusLabel.heightAnchor.constraint(equalToConstant: 24),
            
            // Chevron
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    // MARK: - Configure
    
    func configure(title: String, time: String, status: String) {
        titleLabel.text = title
        timeLabel.text = "⏱ \(time)"
        statusLabel.text = "  \(status)  "
        
        applyStatusStyling(status: status)
    }
    
    private func applyStatusStyling(status: String) {
        switch status.lowercased() {
            
        case "in progress":
            // Card styling
            containerView.backgroundColor = AppColors.cardPrimary
            
            // Icon styling
            iconContainerView.backgroundColor = AppColors.inProgress
            iconImageView.image = UIImage(systemName: "play.fill")
            iconImageView.tintColor = .white
            
            // Text styling
            titleLabel.textColor = AppColors.textPrimary
            timeLabel.textColor = AppColors.textPrimary.withAlphaComponent(0.7)
            
            // Status badge
            statusLabel.backgroundColor = AppColors.inProgress.withAlphaComponent(0.2)
            statusLabel.textColor = AppColors.inProgress
            
            // Chevron
            chevronImageView.tintColor = AppColors.inProgress
            
        case "completed":
            // Card styling
            containerView.backgroundColor = AppColors.cardPrimary
            
            // Icon styling
            iconContainerView.backgroundColor = AppColors.completed
            iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
            iconImageView.tintColor = .white
            
            // Text styling
            titleLabel.textColor = AppColors.textPrimary
            timeLabel.textColor = AppColors.textPrimary.withAlphaComponent(0.7)
            
            // Status badge
            statusLabel.backgroundColor = AppColors.completed.withAlphaComponent(0.2)
            statusLabel.textColor = AppColors.completed
            
            // Chevron
            chevronImageView.tintColor = AppColors.completed
            
        case "locked":
            // Card styling - more muted
            containerView.backgroundColor = AppColors.cardSecondary.withAlphaComponent(0.5)
            
            // Icon styling
            iconContainerView.backgroundColor = AppColors.locked.withAlphaComponent(0.3)
            iconImageView.image = UIImage(systemName: "lock.fill")
            iconImageView.tintColor = AppColors.locked
            
            // Text styling - dimmed
            titleLabel.textColor = AppColors.textPrimary.withAlphaComponent(0.5)
            timeLabel.textColor = AppColors.textPrimary.withAlphaComponent(0.4)
            
            // Status badge
            statusLabel.backgroundColor = AppColors.locked.withAlphaComponent(0.2)
            statusLabel.textColor = AppColors.locked
            
            // Chevron - hidden or dimmed
            chevronImageView.tintColor = AppColors.locked.withAlphaComponent(0.3)
            
        default:
            // Default fallback
            containerView.backgroundColor = AppColors.cardPrimary
            iconContainerView.backgroundColor = AppColors.progress
            iconImageView.image = UIImage(systemName: "flask.fill")
            titleLabel.textColor = AppColors.textPrimary
            timeLabel.textColor = AppColors.textPrimary.withAlphaComponent(0.7)
            statusLabel.backgroundColor = AppColors.progress.withAlphaComponent(0.2)
            statusLabel.textColor = AppColors.progress
            chevronImageView.tintColor = AppColors.icon
        }
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        timeLabel.text = nil
        statusLabel.text = nil
    }
}
