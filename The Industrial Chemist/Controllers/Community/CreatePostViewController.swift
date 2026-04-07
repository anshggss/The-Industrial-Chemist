//
//  CreatePostViewController.swift
//  The Industrial Chemist
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreatePostViewController: UIViewController {

    // MARK: - Constants
    private let bgColor   = UIColor(red: 26/255, green: 1/255, blue: 41/255, alpha: 1.0)
    private let purple    = UIColor(red: 0.74, green: 0.58, blue: 0.98, alpha: 1.0)
    private let fieldBg   = UIColor(red: 40/255, green: 10/255, blue: 60/255, alpha: 1.0)

    private let communityID: String
    var onPostCreated: (() -> Void)?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var titleField: UITextField = {
        let f = UITextField()
        f.attributedPlaceholder = NSAttributedString(
            string: "Post title",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.3)]
        )
        f.textColor = .white
        f.font = .systemFont(ofSize: 15)
        f.backgroundColor = fieldBg
        f.layer.cornerRadius = 12
        f.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        f.leftViewMode = .always
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    private lazy var bodyTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.font = .systemFont(ofSize: 15)
        tv.backgroundColor = fieldBg
        tv.layer.cornerRadius = 12
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        return tv
    }()

    private lazy var bodyPlaceholder: UILabel = {
        let l = UILabel()
        l.text = "Write your post..."
        l.textColor = UIColor.white.withAlphaComponent(0.3)
        l.font = .systemFont(ofSize: 15)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var postButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Post", for: .normal)
        b.setTitleColor(bgColor, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        b.backgroundColor = purple
        b.layer.cornerRadius = 14
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(postTapped), for: .touchUpInside)
        return b
    }()

    private func makeLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.textColor = purple.withAlphaComponent(0.8)
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }

    // MARK: - Init
    init(communityID: String) {
        self.communityID = communityID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

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
        title = "New Post"
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

        let titleLabel = makeLabel("Title")
        let bodyLabel = makeLabel("Body")

        [titleLabel, titleField, bodyLabel, bodyTextView, bodyPlaceholder, postButton]
            .forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleField.heightAnchor.constraint(equalToConstant: 50),

            bodyLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 24),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            bodyTextView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            bodyTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bodyTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bodyTextView.heightAnchor.constraint(equalToConstant: 180),

            bodyPlaceholder.topAnchor.constraint(equalTo: bodyTextView.topAnchor, constant: 10),
            bodyPlaceholder.leadingAnchor.constraint(equalTo: bodyTextView.leadingAnchor, constant: 13),

            postButton.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 32),
            postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            postButton.heightAnchor.constraint(equalToConstant: 52),
            postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Actions
    @objc private func cancelTapped() { dismiss(animated: true) }

    @objc private func postTapped() {
        let titleText = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let bodyText = bodyTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !titleText.isEmpty else {
            showAlert("Please enter a title for your post.")
            return
        }
        guard !bodyText.isEmpty else {
            showAlert("Please write something in the body of your post.")
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else {
            showAlert("You must be logged in to post.")
            return
        }

        let authorName = UserManager.shared.currentUser?.name ?? "Unknown"

        postButton.isEnabled = false
        postButton.setTitle("Posting...", for: .normal)

        let db = Firestore.firestore()
        let postData: [String: Any] = [
            "title": titleText,
            "body": bodyText,
            "authorUID": uid,
            "authorName": authorName,
            "createdAt": FieldValue.serverTimestamp()
        ]

        db.collection("communities").document(communityID)
            .collection("posts")
            .addDocument(data: postData) { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let error = error {
                        self.postButton.isEnabled = true
                        self.postButton.setTitle("Post", for: .normal)
                        self.showAlert("Failed to post: \(error.localizedDescription)")
                    } else {
                        self.onPostCreated?()
                        self.dismiss(animated: true)
                    }
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

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension CreatePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        bodyPlaceholder.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        bodyPlaceholder.isHidden = !textView.text.isEmpty
    }
}
