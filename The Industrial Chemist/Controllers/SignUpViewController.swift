//
//  SignUpViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 06/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
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
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Create Account"
        l.font = .systemFont(ofSize: 28, weight: .bold)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Sign up to get started"
        l.font = .systemFont(ofSize: 14)
        l.textColor = UIColor.white.withAlphaComponent(0.7)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        tf.layer.cornerRadius = 16
        tf.autocapitalizationType = .words
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        tf.layer.cornerRadius = 16
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
    
    private let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        tf.layer.cornerRadius = 16
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let signUpButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Sign Up", for: .normal)
        b.backgroundColor = UIColor(red: 214/255, green: 176/255, blue: 255/255, alpha: 1)
        b.setTitleColor(.black, for: .normal)
        b.layer.cornerRadius = 24
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let loginLabel: UILabel = {
        let l = UILabel()
        l.text = "Already have an account? Log In"
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
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard Handling
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.contentInset.bottom = keyboardSize.height
        scrollView.scrollIndicatorInsets.bottom = keyboardSize.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
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

    // MARK: - Actions

    @objc private func signUpTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert("Please fill all fields")
            return
        }

        if password != confirmPassword {
            showAlert("Passwords do not match")
            return
        }
        
        if password.count < 6 {
            showAlert("Password must be at least 6 characters")
            return
        }

        showLoading()

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.hideLoading()
                self.showAlert(error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else {
                self.hideLoading()
                return
            }

            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "uid": uid,
                "name": name,
                "email": email,
                "phone": phone,
                "experience": 0,
                "createdAt": FieldValue.serverTimestamp()
            ]) { error in
                self.hideLoading()
                
                if let error = error {
                    self.showAlert("Error saving user data: \(error.localizedDescription)")
                    return
                }

                print("✅ User created and data saved")
                
                let user = AppUser(
                    uid: uid,
                    name: name,
                    email: email,
                    phone: phone,
                    experience: 0
                )
                UserManager.shared.currentUser = user

                let tabBarVC = TabBarViewController()
                tabBarVC.modalPresentationStyle = .fullScreen
                self.present(tabBarVC, animated: true)
            }
        }
    }

    @objc private func loginTapped() {
        dismiss(animated: true)
    }

    // MARK: - UI Setup

    private func setupIcons() {
        nameTextField.leftView = leftIcon("person")
        nameTextField.leftViewMode = .always
        
        phoneTextField.leftView = leftIcon("phone")
        phoneTextField.leftViewMode = .always
        
        emailTextField.leftView = leftIcon("envelope")
        emailTextField.leftViewMode = .always
        
        passwordTextField.leftView = leftIcon("lock")
        passwordTextField.leftViewMode = .always
        
        confirmPasswordTextField.leftView = leftIcon("lock.fill")
        confirmPasswordTextField.leftViewMode = .always
    }

    private func setupPlaceholderColor() {
        let color = UIColor.white.withAlphaComponent(0.6)
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [.foregroundColor: color])
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [.foregroundColor: color])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.foregroundColor: color])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor: color])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [.foregroundColor: color])
    }

    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        loginLabel.isUserInteractionEnabled = true
        loginLabel.addGestureRecognizer(tap)
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

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Sign Up", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(topImageView)
        view.addSubview(cardView)
        
        cardView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(signUpButton)
        contentView.addSubview(loginLabel)

        NSLayoutConstraint.activate([
            // Top Image
            topImageView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30),

            // Card View
            cardView.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -32),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: cardView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Name TextField
            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Phone TextField
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 14),
            phoneTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),

            // Email TextField
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 14),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            // Password TextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 14),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Confirm Password TextField
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 14),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),

            // Sign Up Button
            signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 24),
            signUpButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            // Login Label
            loginLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            loginLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
}
