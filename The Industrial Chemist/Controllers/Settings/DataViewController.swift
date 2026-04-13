import UIKit

class DataViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private struct DataItem {
        let icon: String
        let title: String
        let body: String
    }

    private let items: [DataItem] = [
        DataItem(
            icon: "person.fill",
            title: "Account Information",
            body: "We collect your name and email address when you create an account. This is used solely to identify you within the app, personalise your experience, and let you recover access to your account."
        ),
        DataItem(
            icon: "chart.bar.fill",
            title: "Learning Progress",
            body: "Your experiment progress, completed phases, test scores, and XP are stored in Firebase Firestore. This data powers your home screen, leaderboard ranking, and streak calendar. It is tied to your account and is not shared with third parties."
        ),
        DataItem(
            icon: "flame.fill",
            title: "Streak & Activity",
            body: "We record the dates on which you complete learning activity in order to calculate and display your daily streak. This data is stored per account and is only used to show your streak count and calendar within the app."
        ),
        DataItem(
            icon: "list.number",
            title: "Leaderboard Data",
            body: "Your display name and XP total are visible to other users on the global leaderboard. This is the only data shared with other users. You can choose a display name that does not reveal your real identity."
        ),
        DataItem(
            icon: "bubble.left.and.bubble.right.fill",
            title: "Community Posts",
            body: "Any content you post in Community Forums is visible to all users of the app. Do not include personal information in posts. We do not sell or share community content with third parties, but it is publicly visible within the app."
        ),
        DataItem(
            icon: "crown.fill",
            title: "Subscription Status",
            body: "We store whether your account has an active Premium subscription. Payment is processed entirely by Apple via the App Store — we never see or store your payment card details."
        ),
        DataItem(
            icon: "gearshape.fill",
            title: "App Usage Analytics",
            body: "We may collect anonymised, aggregated data about how features are used (e.g. which experiments are opened, session length) to help us improve the app. This data cannot be used to identify you individually."
        ),
        DataItem(
            icon: "lock.shield.fill",
            title: "How We Protect Your Data",
            body: "All data is stored in Google Firebase, protected by industry-standard encryption in transit and at rest. We do not sell your personal data. Access to your data is restricted to authorised members of The Industrial Chemist team."
        ),
        DataItem(
            icon: "trash.fill",
            title: "Deleting Your Data",
            body: "You can request deletion of your account and all associated data at any time by contacting us through Settings. Upon deletion, your profile, progress, streak history, and community posts will be permanently removed from our systems."
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupScrollView()
        buildContent()
    }

    private func setupNav() {
        view.backgroundColor = AppColors.background
        title = "Your Data"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.titleTextAttributes = [.foregroundColor: AppColors.cardPrimary]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = AppColors.cardPrimary
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

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
        ])
    }

    private func buildContent() {
        let outerStack = UIStackView()
        outerStack.axis = .vertical
        outerStack.spacing = 12
        outerStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(outerStack)

        NSLayoutConstraint.activate([
            outerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            outerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            outerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
        ])

        // Header blurb
        let header = makeHeaderBlurb()
        outerStack.addArrangedSubview(header)
        outerStack.setCustomSpacing(20, after: header)

        // Data item cards
        for item in items {
            outerStack.addArrangedSubview(makeCard(item))
        }

        // Footer note
        outerStack.setCustomSpacing(24, after: outerStack.arrangedSubviews.last!)
        outerStack.addArrangedSubview(makeFooterNote())
    }

    // MARK: - Subview builders

    private func makeHeaderBlurb() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(hex: "#9D4EDD").withAlphaComponent(0.12)
        container.layer.cornerRadius = 14
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(hex: "#9D4EDD").withAlphaComponent(0.3).cgColor

        let icon = UIImageView(image: UIImage(systemName: "info.circle.fill"))
        icon.tintColor = UIColor(hex: "#b66dff")
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "We believe you should know exactly what data The Industrial Chemist collects and why. Here is a plain-language summary of every category of data we hold."
        label.textColor = UIColor(hex: "#c4a8e0")
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let row = UIStackView(arrangedSubviews: [icon, label])
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .top
        row.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(row)
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),
            row.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
        ])
        return container
    }

    private func makeCard(_ item: DataItem) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(hex: "#1f0230")
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(hex: "#3a0558").cgColor

        // Icon pill
        let iconBg = UIView()
        iconBg.backgroundColor = UIColor(hex: "#9D4EDD").withAlphaComponent(0.15)
        iconBg.layer.cornerRadius = 10
        iconBg.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView(image: UIImage(systemName: item.icon))
        iconView.tintColor = UIColor(hex: "#b66dff")
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconBg.addSubview(iconView)

        NSLayoutConstraint.activate([
            iconBg.widthAnchor.constraint(equalToConstant: 38),
            iconBg.heightAnchor.constraint(equalToConstant: 38),
            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
        ])

        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.textColor = UIColor(hex: "#E6C9FF")
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 0

        let headerRow = UIStackView(arrangedSubviews: [iconBg, titleLabel])
        headerRow.axis = .horizontal
        headerRow.spacing = 12
        headerRow.alignment = .center

        let bodyLabel = UILabel()
        bodyLabel.text = item.body
        bodyLabel.textColor = UIColor(hex: "#c4a8e0")
        bodyLabel.font = .systemFont(ofSize: 14, weight: .regular)
        bodyLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [headerRow, bodyLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
        ])

        return container
    }

    private func makeFooterNote() -> UIView {
        let label = UILabel()
        label.text = "Last updated: April 2026 · The Industrial Chemist"
        label.textColor = UIColor(hex: "#7a5e96")
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
}
