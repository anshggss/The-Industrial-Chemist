import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

class Login2ViewController: UIViewController {

    // MARK: - Loading View
    private var loadingView: UIView?

    // MARK: - UI Elements

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

    // Apple button - back in!
    private let appleButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = .white
        b.layer.cornerRadius = 22
        b.setImage(UIImage(systemName: "applelogo"), for: .normal)
        b.tintColor = .black
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    // Google button
    private let googleButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = .white
        b.layer.cornerRadius = 22
        b.setImage(UIImage(systemName: "g.circle.fill"), for: .normal)
        b.tintColor = .black
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let leftLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let rightLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupIcons()
        setupPlaceholderColor()
        setupActions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let user = Auth.auth().currentUser {
            showLoading()
            fetchUserData(uid: user.uid)
        }
    }

    // MARK: - Loading Functions

    private func showLoading() {
        let bgView = UIView(frame: view.bounds)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = bgView.center
        spinner.startAnimating()

        bgView.addSubview(spinner)
        view.addSubview(bgView)

        loadingView = bgView
        view.isUserInteractionEnabled = false
    }

    private func hideLoading() {
        loadingView?.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    private func fetchUserData(uid: String) {
        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            self.hideLoading()

            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }

            guard let data = snapshot?.data() else {
                self.showAlert(message: "User data not found")
                return
            }

            let user = AppUser(
                uid: uid,
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                phone: data["phone"] as? String ?? "",
                experience: data["experience"] as? Int ?? 0
            )

            UserManager.shared.currentUser = user
            self.navigateToHome()
        }
    }
    
    // MARK: - Create or Fetch User for Social Login
    
    private func handleSocialLogin(uid: String, email: String?, name: String?) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.hideLoading()
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            if let data = snapshot?.data(), snapshot?.exists == true {
                // User exists
                let user = AppUser(
                    uid: uid,
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    phone: data["phone"] as? String ?? "",
                    experience: data["experience"] as? Int ?? 0
                )
                
                UserManager.shared.currentUser = user
                self.hideLoading()
                self.navigateToHome()
            } else {
                // New user
                let userData: [String: Any] = [
                    "uid": uid,
                    "name": name ?? "",
                    "email": email ?? "",
                    "phone": "",
                    "experience": 0,
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                userRef.setData(userData) { error in
                    self.hideLoading()
                    
                    if let error = error {
                        self.showAlert(message: error.localizedDescription)
                        return
                    }
                    
                    let user = AppUser(
                        uid: uid,
                        name: name ?? "",
                        email: email ?? "",
                        phone: "",
                        experience: 0
                    )
                    
                    UserManager.shared.currentUser = user
                    self.navigateToHome()
                }
            }
        }
    }
    
    private func navigateToHome() {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }

    // MARK: - Actions

    @objc private func signInTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {
            showAlert(message: "Please enter email and password")
            return
        }

        showLoading()

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.hideLoading()
                self.showAlert(message: error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else {
                self.hideLoading()
                return
            }

            self.fetchUserData(uid: uid)
        }
    }
    
    // MARK: - Google Sign In
    
    @objc private func googleSignInTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            showAlert(message: "Firebase configuration error")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        showLoading()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.hideLoading()
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.hideLoading()
                self.showAlert(message: "Failed to get Google credentials")
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.hideLoading()
                    self.showAlert(message: error.localizedDescription)
                    return
                }
                
                guard let firebaseUser = authResult?.user else {
                    self.hideLoading()
                    return
                }
                
                self.handleSocialLogin(
                    uid: firebaseUser.uid,
                    email: firebaseUser.email,
                    name: firebaseUser.displayName
                )
            }
        }
    }
    
    // MARK: - Apple Sign In (Coming Soon)
    
    @objc private func appleSignInTapped() {
        let alert = UIAlertController(
            title: "Coming Soon",
            message: "Sign in with Apple will be available in a future update.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func forgotPasswordTapped() {
        let storyboard = UIStoryboard(name: "Forgot Password", bundle: nil)
        guard let forgotVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController else { return }
        forgotVC.modalPresentationStyle = .fullScreen
        present(forgotVC, animated: true)
    }

    @objc private func createAccountTapped() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .pageSheet  // Modal presentation
        
        // Optional: Customize the sheet size (iOS 15+)
        if let sheet = signUpVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(signUpVC, animated: true)
    }

    // MARK: - UI Setup

    private func setupIcons() {
        emailTextField.leftView = leftIcon("envelope")
        emailTextField.leftViewMode = .always
        passwordTextField.leftView = leftIcon("lock")
        passwordTextField.leftViewMode = .always
    }

    private func setupPlaceholderColor() {
        let color = UIColor.white.withAlphaComponent(0.6)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.foregroundColor: color])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor: color])
    }

    private func setupActions() {
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        
        // Social login buttons
        googleButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(createAccountTapped))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(tap)
    }

    private func leftIcon(_ system: String) -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        let img = UIImageView(frame: CGRect(x: 12, y: 15, width: 20, height: 20))
        img.image = UIImage(systemName: system)
        img.tintColor = .white
        v.addSubview(img)
        return v
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(topImageView)
        view.addSubview(cardView)

        // Add subviews individually
        cardView.addSubview(titleLabel)
        cardView.addSubview(emailTextField)
        cardView.addSubview(passwordTextField)
        cardView.addSubview(forgotButton)
        cardView.addSubview(signInButton)
        cardView.addSubview(appleButton)
        cardView.addSubview(googleButton)
        cardView.addSubview(leftLine)
        cardView.addSubview(orLabel)
        cardView.addSubview(rightLine)
        cardView.addSubview(createAccountLabel)

        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),

            cardView.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -32),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            forgotButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            forgotButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

            signInButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),

            // Apple button - left of center
            appleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 24),
            appleButton.trailingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: -12),
            appleButton.widthAnchor.constraint(equalToConstant: 44),
            appleButton.heightAnchor.constraint(equalToConstant: 44),

            // Google button - right of center
            googleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 24),
            googleButton.leadingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: 12),
            googleButton.widthAnchor.constraint(equalToConstant: 44),
            googleButton.heightAnchor.constraint(equalToConstant: 44),

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

            createAccountLabel.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 16),
            createAccountLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }
}
