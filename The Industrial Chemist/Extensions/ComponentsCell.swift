import UIKit

class ComponentCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Info Button (right side)
            infoButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            infoButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            infoButton.widthAnchor.constraint(equalToConstant: 24),
            infoButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -8),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -8),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func infoButtonTapped() {
        print("Info button tapped for: \(titleLabel.text ?? "")")
    }
    
    // MARK: - Configure
    
    func configure(title: String, subtitle: String, status: ComponentsTableViewController.ComponentStatus) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        applyStatusStyling(status: status)
    }
    
    private func applyStatusStyling(status: ComponentsTableViewController.ComponentStatus) {
        // All cells have same base appearance - fully enabled
        containerView.backgroundColor = AppColors.cardPrimary
        titleLabel.textColor = AppColors.textPrimary
        subtitleLabel.textColor = AppColors.textPrimary.withAlphaComponent(0.7)
        
        switch status {
            
        case .active:
            // In Progress - Purple accent with border
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = AppColors.inProgress.cgColor
            infoButton.tintColor = AppColors.inProgress
            
        case .completed:
            // Completed - Teal accent
            containerView.layer.borderWidth = 0
            infoButton.tintColor = AppColors.completed
            
        case .pending:
            // Pending - Default accent (no special indicator)
            containerView.layer.borderWidth = 0
            infoButton.tintColor = AppColors.progress
        }
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        containerView.layer.borderWidth = 0
    }
}
