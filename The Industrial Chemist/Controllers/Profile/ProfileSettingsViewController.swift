import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileSettingsViewController: UIViewController {

    private let db = Firestore.firestore()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let avatarImageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
    private let nameField = UITextField()
    private let emailField = UITextField()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        loadUserData()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 24/255, green: 4/255, blue: 46/255, alpha: 1)
        title = "Profile"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
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

        // Avatar
        avatarImageView.tintColor = UIColor(red: 0.55, green: 0.38, blue: 0.82, alpha: 1)
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        // Name field
        configure(nameField, placeholder: "Full name")
        nameField.returnKeyType = .done
        nameField.delegate = self

        // Email field — read only
        configure(emailField, placeholder: "Email")
        emailField.isEnabled = false
        emailField.textColor = UIColor.white.withAlphaComponent(0.4)

        // Save button
        saveButton.setTitle("Save changes", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.55, green: 0.38, blue: 0.82, alpha: 1)
        saveButton.layer.cornerRadius = 12
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("DELETE ACCOUNT", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.layer.borderColor = UIColor.systemRed.cgColor
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.cornerRadius = 12
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        deleteButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            avatarImageView,
            makeLabel("Name"), nameField,
            makeLabel("Email"), emailField,
            saveButton,
            deleteButton
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.setCustomSpacing(20, after: avatarImageView)
        stack.setCustomSpacing(24, after: emailField)
        stack.setCustomSpacing(16, after: saveButton)
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    private func loadUserData() {
        nameField.text = UserManager.shared.currentUser?.name
        emailField.text = UserManager.shared.currentUser?.email
            ?? Auth.auth().currentUser?.email
    }

    // MARK: - Actions

    @objc private func saveTapped() {
        guard let uid = Auth.auth().currentUser?.uid,
              let newName = nameField.text?.trimmingCharacters(in: .whitespaces),
              !newName.isEmpty else {
            showAlert(message: "Name cannot be empty.")
            return
        }

        saveButton.isEnabled = false
        db.collection("users").document(uid).updateData(["name": newName]) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.saveButton.isEnabled = true
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                } else {
                    // Update in-memory user
                    if let user = UserManager.shared.currentUser {
                        UserManager.shared.currentUser = AppUser(
                            uid: user.uid, name: newName, email: user.email,
                            phone: user.phone, experience: user.experience,
                            weeklyXP: user.weeklyXP, currentStreak: user.currentStreak,
                            division: user.division, hasSubscription: user.hasSubscription
                        )
                    }
                    self.showAlert(title: "Saved", message: "Your name has been updated.")
                }
            }
        }
    }

    @objc private func deleteTapped() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "This will permanently delete your account and all data. This cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.showAlert(message: "Account deletion is coming soon. Please contact support.")
        })
        present(alert, animated: true)
    }

    // MARK: - Helpers

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }

    private func configure(_ tf: UITextField, placeholder: String) {
        tf.placeholder = placeholder
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.3)]
        )
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        tf.textColor = .white
        tf.layer.cornerRadius = 12
        tf.setLeftPaddingPoints(12)
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }

    private func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ProfileSettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: 48))
        leftView = paddingView
        leftViewMode = .always
    }
}
