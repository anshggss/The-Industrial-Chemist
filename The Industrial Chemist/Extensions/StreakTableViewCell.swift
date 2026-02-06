import UIKit

class StreakTableViewCell: UITableViewCell {
    
    static let identifier = "StreakCell"
    
    private let containerView = UIView()
    private let leftMascotImageView = UIImageView()
    private let rightMascotImageView = UIImageView()
    private let streakLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = AppColors.cardPrimary
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.12
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        contentView.addSubview(containerView)
        
        // Left Mascot
        leftMascotImageView.translatesAutoresizingMaskIntoConstraints = false
        leftMascotImageView.image = UIImage(named: "mascot_left") // Replace with your asset name
        leftMascotImageView.contentMode = .scaleAspectFit
        contentView.addSubview(leftMascotImageView)
        
        // Right Mascot
        rightMascotImageView.translatesAutoresizingMaskIntoConstraints = false
        rightMascotImageView.image = UIImage(named: "mascot_right") // Replace with your asset name
        rightMascotImageView.contentMode = .scaleAspectFit
        contentView.addSubview(rightMascotImageView)
        
        // Streak Label
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        streakLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        streakLabel.textColor = AppColors.textPrimary
        streakLabel.textAlignment = .center
        containerView.addSubview(streakLabel)
        
        NSLayoutConstraint.activate([
            // Left Mascot
            leftMascotImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftMascotImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leftMascotImageView.widthAnchor.constraint(equalToConstant: 50),
            leftMascotImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Container - 10pt spacing from mascots
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leftMascotImageView.trailingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: rightMascotImageView.leadingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 56),
            
            // Right Mascot
            rightMascotImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightMascotImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rightMascotImageView.widthAnchor.constraint(equalToConstant: 50),
            rightMascotImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Streak Label
            streakLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            streakLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(days: Int) {
        streakLabel.text = "🔥 \(days) Days"
    }
    
    // Optional: Use same mascot image mirrored for right side
    func configure(days: Int, mascotImageName: String) {
        streakLabel.text = "🔥 \(days) Days"
        
        leftMascotImageView.image = UIImage(named: mascotImageName)
        
        // Mirror the mascot for right side
        if let originalImage = UIImage(named: mascotImageName) {
            rightMascotImageView.image = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale, orientation: .upMirrored)
        }
    }
}
