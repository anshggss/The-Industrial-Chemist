import UIKit

class Login2ViewController: UIViewController {

    // MARK: - Top Image Container
    private let topImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "login") // Asset name
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - Login Card
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 48/255, green: 16/255, blue: 72/255, alpha: 1)
        v.layer.cornerRadius = 32
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - Title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Email
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.textColor = .white
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        tf.layer.cornerRadius = 16
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // MARK: - Password
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textColor = .white
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        tf.layer.cornerRadius = 16
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // MARK: - Forgot
    private let forgotButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Forgot Password", for: .normal)
        btn.setTitleColor(.systemPink, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Sign In
    private let signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign In", for: .normal)
        btn.backgroundColor = UIColor(red: 214/255, green: 176/255, blue: 255/255, alpha: 1)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 22
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Social
    private let appleButton = Login2ViewController.circleButton(systemName: "applelogo")
    private let googleButton = Login2ViewController.circleButton(systemName: "g.circle.fill")

    private let createAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Create an account"
        label.textColor = .systemPink
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupIcons()
    }

    // MARK: - UI Setup
    private func setupUI() {

        view.addSubview(topImageView)
        view.addSubview(cardView)

        cardView.addSubview(titleLabel)
        cardView.addSubview(emailTextField)
        cardView.addSubview(passwordTextField)
        cardView.addSubview(forgotButton)
        cardView.addSubview(signInButton)
        cardView.addSubview(appleButton)
        cardView.addSubview(googleButton)
        cardView.addSubview(createAccountLabel)

        NSLayoutConstraint.activate([

            // Top Image
            topImageView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),

            // Card View
            cardView.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -32),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Title
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            // Email
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),

            // Password
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),

            // Forgot
            forgotButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            forgotButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

            // Sign In
            signInButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 48),

            // Social
            appleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            appleButton.trailingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: -10),
            appleButton.widthAnchor.constraint(equalToConstant: 44),
            appleButton.heightAnchor.constraint(equalToConstant: 44),

            googleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            googleButton.leadingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: 10),
            googleButton.widthAnchor.constraint(equalToConstant: 44),
            googleButton.heightAnchor.constraint(equalToConstant: 44),

            // Create Account
            createAccountLabel.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 20),
            createAccountLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }

    // MARK: - Icons
    private func setupIcons() {
        emailTextField.leftView = leftIcon("envelope")
        emailTextField.leftViewMode = .always

        passwordTextField.leftView = leftIcon("lock")
        passwordTextField.leftViewMode = .always
    }

    private func leftIcon(_ systemName: String) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
        let icon = UIImageView(frame: CGRect(x: 12, y: 2, width: 20, height: 20))
        icon.image = UIImage(systemName: systemName)
        icon.tintColor = .systemPink
        container.addSubview(icon)
        return container
    }

    private static func circleButton(systemName: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 22
        btn.setImage(UIImage(systemName: systemName), for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
}

