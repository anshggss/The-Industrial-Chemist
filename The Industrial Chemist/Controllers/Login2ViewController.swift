import UIKit

class Login2ViewController: UIViewController {

    private let topImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "login")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 48/255, green: 16/255, blue: 72/255, alpha: 1)
        v.layer.cornerRadius = 32
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Log In"
        l.font = .systemFont(ofSize: 28, weight: .bold)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.textColor = .white
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        tf.layer.cornerRadius = 16
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textColor = .white
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        tf.layer.cornerRadius = 16
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let forgotButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Forgot Password", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 14)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let signInButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Sign In", for: .normal)
        b.backgroundColor = UIColor(red: 214/255, green: 176/255, blue: 255/255, alpha: 1)
        b.setTitleColor(.black, for: .normal)
        b.layer.cornerRadius = 24
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let appleButton = Login2ViewController.circleButton(image: "applelogo")
    private let googleButton = Login2ViewController.circleButton(image: "g.circle.fill")

    // MARK: - Divider
    private let leftLine = Login2ViewController.dividerLine()
    private let rightLine = Login2ViewController.dividerLine()

    private let orLabel: UILabel = {
        let l = UILabel()
        l.text = "OR"
        l.textColor = .white
        l.font = .systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let createAccountLabel: UILabel = {
        let l = UILabel()
        l.text = "Create an account"
        l.textColor = .white
        l.font = .systemFont(ofSize: 15)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupIcons()
        setupPlaceholderColor()
    }

    private func setupUI() {

        view.addSubview(topImageView)
        view.addSubview(cardView)

        [
            titleLabel,
            emailTextField,
            passwordTextField,
            forgotButton,
            signInButton,
            appleButton,
            googleButton,
            leftLine,
            orLabel,
            rightLine,
            createAccountLabel
        ].forEach { cardView.addSubview($0) }

        NSLayoutConstraint.activate([

            // Top image
            topImageView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),

            // Card
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
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            // Password
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            // Forgot
            forgotButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            forgotButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

            // Sign In
            signInButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),

            // Social
            appleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 24),
            appleButton.trailingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: -12),
            appleButton.widthAnchor.constraint(equalToConstant: 44),
            appleButton.heightAnchor.constraint(equalToConstant: 44),

            googleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 24),
            googleButton.leadingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: 12),
            googleButton.widthAnchor.constraint(equalToConstant: 44),
            googleButton.heightAnchor.constraint(equalToConstant: 44),

            // OR Divider
            orLabel.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 20),
            orLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            leftLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            leftLine.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 40),
            leftLine.trailingAnchor.constraint(equalTo: orLabel.leadingAnchor, constant: -12),
            leftLine.heightAnchor.constraint(equalToConstant: 1),

            rightLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            rightLine.leadingAnchor.constraint(equalTo: orLabel.trailingAnchor, constant: 12),
            rightLine.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -40),
            rightLine.heightAnchor.constraint(equalToConstant: 1),

            // Create Account
            createAccountLabel.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 16),
            createAccountLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }

    private func setupIcons() {
        emailTextField.leftView = leftIcon("envelope")
        emailTextField.leftViewMode = .always

        passwordTextField.leftView = leftIcon("lock")
        passwordTextField.leftViewMode = .always
    }

    private func setupPlaceholderColor() {
        let color = UIColor.white.withAlphaComponent(0.6)
        emailTextField.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [.foregroundColor: color])
        passwordTextField.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [.foregroundColor: color])
    }

    private func leftIcon(_ system: String) -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        let img = UIImageView(frame: CGRect(x: 12, y: 15, width: 20, height: 20))
        img.image = UIImage(systemName: system)
        img.tintColor = .white
        v.addSubview(img)
        return v
    }

    private static func circleButton(image: String) -> UIButton {
        let b = UIButton(type: .system)
        b.backgroundColor = .white
        b.layer.cornerRadius = 22
        b.setImage(UIImage(systemName: image), for: .normal)
        b.tintColor = .black
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }

    private static func dividerLine() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
}

