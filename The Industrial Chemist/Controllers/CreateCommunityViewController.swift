//
//  CreateCommunityViewController.swift
//  The Industrial Chemist
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreateCommunityViewController: UIViewController {

    // MARK: - Constants
    private let bgColor   = UIColor(red: 26/255, green: 1/255, blue: 41/255, alpha: 1.0)
    private let purple    = UIColor(red: 0.74, green: 0.58, blue: 0.98, alpha: 1.0)
    private let fieldBg   = UIColor(red: 40/255, green: 10/255, blue: 60/255, alpha: 1.0)

    var onCommunityCreated: (() -> Void)?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var nameField: UITextField = makeField(placeholder: "Community name", isMultiline: false)
    private lazy var descField: UITextView = makeTextView(placeholder: "Description (optional)")

    private lazy var createButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Create Community", for: .normal)
        b.setTitleColor(bgColor, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        b.backgroundColor = purple
        b.layer.cornerRadius = 14
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        return b
    }()

    private lazy var nameLabel: UILabel = makeLabel("Community Name")
    private lazy var descLabel: UILabel = makeLabel("Description")

    private var descPlaceholderLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        setupNav()
        setupLayout()
        setupKeyboard()
    }

    // MARK: - Setup
    private func setupNav() {
        title = "New Community"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bgColor
        appearance.titleTextAttributes = [.foregroundColor: purple]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = purple

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = purple.withAlphaComponent(0.7)
    }

    private func setupLayout() {
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
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        [nameLabel, nameField, descLabel, descField, createButton].forEach {
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0 as! UIView)
        }

        // Placeholder for descField
        descPlaceholderLabel = UILabel()
        descPlaceholderLabel.text = "What is this community about?"
        descPlaceholderLabel.textColor = UIColor.white.withAlphaComponent(0.3)
        descPlaceholderLabel.font = .systemFont(ofSize: 15)
        descPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descPlaceholderLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameField.heightAnchor.constraint(equalToConstant: 50),

            descLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            descField.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 8),
            descField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descField.heightAnchor.constraint(equalToConstant: 120),

            descPlaceholderLabel.topAnchor.constraint(equalTo: descField.topAnchor, constant: 8),
            descPlaceholderLabel.leadingAnchor.constraint(equalTo: descField.leadingAnchor, constant: 5),

            createButton.topAnchor.constraint(equalTo: descField.bottomAnchor, constant: 32),
            createButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 52),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])

        descField.delegate = self
    }

    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Actions
    @objc private func cancelTapped() { dismiss(animated: true) }

    @objc private func createTapped() {
        guard let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty else {
            showAlert("Please enter a community name.")
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert("You must be logged in to create a community.")
            return
        }

        let userName = UserManager.shared.currentUser?.name ?? "Unknown"
        let desc = descField.text ?? ""

        createButton.isEnabled = false
        createButton.setTitle("Creating...", for: .normal)

        let db = Firestore.firestore()
        let communityData: [String: Any] = [
            "name": name,
            "description": desc == "What is this community about?" ? "" : desc,
            "createdBy": uid,
            "createdByName": userName,
            "memberCount": 1,
            "createdAt": FieldValue.serverTimestamp()
        ]

        var ref: DocumentReference?
        ref = db.collection("communities").addDocument(data: communityData) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.createButton.isEnabled = true
                    self.createButton.setTitle("Create Community", for: .normal)
                    self.showAlert("Failed to create community: \(error.localizedDescription)")
                }
                return
            }

            // Auto-join the creator
            if let communityID = ref?.documentID {
                db.collection("communities").document(communityID)
                    .collection("members").document(uid)
                    .setData(["joinedAt": FieldValue.serverTimestamp()])
            }

            DispatchQueue.main.async {
                self.onCommunityCreated?()
                self.dismiss(animated: true)
            }
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            scrollView.contentInset.bottom = frame.height
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }

    @objc private func dismissKeyboard() { view.endEditing(true) }

    // MARK: - Helpers
    private func makeField(placeholder: String, isMultiline: Bool) -> UITextField {
        let f = UITextField()
        f.placeholder = placeholder
        f.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.3)]
        )
        f.textColor = .white
        f.font = .systemFont(ofSize: 15)
        f.backgroundColor = UIColor(red: 40/255, green: 10/255, blue: 60/255, alpha: 1.0)
        f.layer.cornerRadius = 12
        f.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        f.leftViewMode = .always
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }

    private func makeTextView(placeholder: String) -> UITextView {
        let tv = UITextView()
        tv.textColor = .white
        tv.font = .systemFont(ofSize: 15)
        tv.backgroundColor = UIColor(red: 40/255, green: 10/255, blue: 60/255, alpha: 1.0)
        tv.layer.cornerRadius = 12
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }

    private func makeLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.textColor = purple.withAlphaComponent(0.8)
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension CreateCommunityViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        descPlaceholderLabel.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        descPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}
