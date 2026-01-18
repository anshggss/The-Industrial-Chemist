import UIKit

class ProfileSettingsViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 24/255, green: 4/255, blue: 46/255, alpha: 1)

        title = "Profile"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        let avatar = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        avatar.tintColor = .systemBlue
        avatar.contentMode = .scaleAspectFit

        let changeAvatar = makeLinkLabel("CHANGE AVATAR")

        let nameField = makeTextField("diya")
        let usernameField = makeTextField("dizzuu")
        let passwordField = makeTextField("", secure: true)
        let emailField = makeTextField("dizzy9999@gmail.com")

        let deleteButton = makeOutlinedButton(title: "DELETE ACCOUNT", color: .systemRed)

        let stack = UIStackView(arrangedSubviews: [
            avatar,
            changeAvatar,
            makeLabel("Name"), nameField,
            makeLabel("Username"), usernameField,
            makeLabel("Password"), passwordField,
            makeLabel("Email"), emailField,
            deleteButton
        ])

        stack.axis = .vertical
        stack.spacing = 16

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        avatar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatar.heightAnchor.constraint(equalToConstant: 120),

            stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    // MARK: - Helpers

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }

    private func makeTextField(_ text: String, secure: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.text = text
        tf.isSecureTextEntry = secure
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        tf.textColor = .white
        tf.layer.cornerRadius = 12
        tf.setLeftPaddingPoints(12)
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return tf
    }

    private func makeLinkLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }

    private func makeOutlinedButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }
}

// Padding helper
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: 48))
        leftView = paddingView
        leftViewMode = .always
    }
}
