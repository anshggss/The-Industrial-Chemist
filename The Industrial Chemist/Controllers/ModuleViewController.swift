import UIKit

class ModuleViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background
        title = "Modules"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white

        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Continue your learning journey"
        subtitleLabel.textColor = .lightGray
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .medium)

        let gasPrepCard = createModuleCard(
            title: "Gas Preparation", 
            subtitle: "Continue Understanding", 
            progressText: "50%", 
            progressValue: 0.5, 
            isLocked: false, 
            action: #selector(gasPrepTapped)
        )

        let upNextLabel = UILabel()
        upNextLabel.text = "Up Next"
        upNextLabel.textColor = .white
        upNextLabel.font = .systemFont(ofSize: 22, weight: .bold)

        let acidBaseCard = createModuleCard(
            title: "Acid Base Preparation", 
            subtitle: "Start Learning", 
            progressText: "0%", 
            progressValue: 0.0, 
            isLocked: true, 
            action: #selector(acidBaseTapped)
        )

        let stack = UIStackView(arrangedSubviews: [
            subtitleLabel, 
            gasPrepCard, 
            upNextLabel, 
            acidBaseCard
        ])
        stack.axis = .vertical
        stack.spacing = 24
        stack.setCustomSpacing(12, after: upNextLabel)

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    private func createModuleCard(title: String, subtitle: String, progressText: String, progressValue: Float, isLocked: Bool, action: Selector) -> UIView {
        let card = UIView()
        card.layer.cornerRadius = 20
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.2
        card.layer.shadowRadius = 10
        card.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        card.backgroundColor = isLocked ? UIColor(white: 0.2, alpha: 1) : AppColors.cardPrimary
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = isLocked ? .white : AppColors.textPrimary
        
        let subLabel = UILabel()
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.text = subtitle
        subLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subLabel.textColor = isLocked ? .lightGray : AppColors.textPrimary.withAlphaComponent(0.7)
        
        let playImageView = UIImageView(image: UIImage(systemName: isLocked ? "lock.fill" : "play.fill"))
        playImageView.translatesAutoresizingMaskIntoConstraints = false
        playImageView.tintColor = isLocked ? .lightGray : AppColors.textPrimary
        playImageView.contentMode = .scaleAspectFit
        
        let progressTitle = UILabel()
        progressTitle.translatesAutoresizingMaskIntoConstraints = false
        progressTitle.text = isLocked ? "20 mins" : "Progress"
        progressTitle.font = .systemFont(ofSize: 15, weight: .bold)
        progressTitle.textColor = isLocked ? .lightGray : AppColors.textPrimary
        
        let progressPercent = UILabel()
        progressPercent.translatesAutoresizingMaskIntoConstraints = false
        progressPercent.text = progressText
        progressPercent.font = .systemFont(ofSize: 15, weight: .regular)
        progressPercent.textColor = isLocked ? .lightGray : AppColors.textPrimary
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = progressValue
        progressView.progressTintColor = isLocked ? .gray : AppColors.progress
        progressView.trackTintColor = isLocked ? .lightGray : AppColors.progressTrack.withAlphaComponent(0.4)
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: action)
        card.addGestureRecognizer(tap)
        card.isUserInteractionEnabled = true
        
        card.addSubview(titleLabel)
        card.addSubview(subLabel)
        card.addSubview(playImageView)
        card.addSubview(progressTitle)
        card.addSubview(progressPercent)
        card.addSubview(progressView)

        let timerIcon = UIImageView(image: UIImage(systemName: "timer"))
        timerIcon.translatesAutoresizingMaskIntoConstraints = false
        timerIcon.tintColor = .darkGray
        timerIcon.isHidden = !isLocked
        card.addSubview(timerIcon)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 160),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: playImageView.leadingAnchor, constant: -10),
            
            playImageView.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            playImageView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            playImageView.widthAnchor.constraint(equalToConstant: 30),
            playImageView.heightAnchor.constraint(equalToConstant: 30),
            
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            progressView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            progressView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            progressPercent.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -12),
            progressPercent.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            
            progressTitle.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -12),
        ])

        if isLocked {
            NSLayoutConstraint.activate([
                timerIcon.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
                timerIcon.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -12),
                timerIcon.widthAnchor.constraint(equalToConstant: 18),
                timerIcon.heightAnchor.constraint(equalToConstant: 18),
                
                progressTitle.leadingAnchor.constraint(equalTo: timerIcon.trailingAnchor, constant: 6)
            ])
        } else {
            NSLayoutConstraint.activate([
                progressTitle.leadingAnchor.constraint(equalTo: progressView.leadingAnchor)
            ])
        }
        
        return card
    }

    @objc private func gasPrepTapped() {
        let vc = GasPrepNewViewController(nibName: "GasPrepNew", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func acidBaseTapped() {
        let alert = UIAlertController(title: "Module Locked", message: "Complete previous modules to unlock this one.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
