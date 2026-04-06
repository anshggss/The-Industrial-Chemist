//
//  CommunityDetailViewController.swift
//  The Industrial Chemist
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CommunityDetailViewController: UIViewController {

    // MARK: - Constants
    private let bgColor   = UIColor(red: 26/255, green: 1/255, blue: 41/255, alpha: 1.0)
    private let purple    = UIColor(red: 0.74, green: 0.58, blue: 0.98, alpha: 1.0)
    private let cardColor = UIColor(red: 40/255, green: 10/255, blue: 60/255, alpha: 1.0)

    // MARK: - Data
    private let community: Community
    private var posts: [Post] = []
    private let db = Firestore.firestore()

    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 20, right: 0)
        tv.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private lazy var emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "No posts yet.\nTap + to share something!"
        l.textColor = purple.withAlphaComponent(0.6)
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.numberOfLines = 0
        l.textAlignment = .center
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = purple
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    // MARK: - Init
    init(community: Community) {
        self.community = community
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        setupNav()
        setupLayout()
        fetchPosts()
    }

    // MARK: - Setup
    private func setupNav() {
        title = community.name
        navigationController?.navigationBar.prefersLargeTitles = false

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bgColor
        appearance.titleTextAttributes = [.foregroundColor: purple]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = purple

        let plusButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(createPostTapped)
        )
        plusButton.tintColor = purple
        navigationItem.rightBarButtonItem = plusButton
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Data
    private func fetchPosts() {
        activityIndicator.startAnimating()
        emptyLabel.isHidden = true

        db.collection("communities").document(community.id)
            .collection("posts")
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snap, error in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()

                if let error = error {
                    print("Error fetching posts: \(error)")
                    return
                }

                self.posts = snap?.documents.compactMap {
                    Post(id: $0.documentID, data: $0.data())
                } ?? []

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.emptyLabel.isHidden = !self.posts.isEmpty
                }
            }
    }

    // MARK: - Actions
    @objc private func createPostTapped() {
        let vc = CreatePostViewController(communityID: community.id)
        vc.onPostCreated = { [weak self] in
            self?.fetchPosts()
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
}

// MARK: - UITableViewDataSource / Delegate
extension CommunityDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row], purple: purple, cardColor: cardColor)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - PostCell
class PostCell: UITableViewCell {
    static let reuseID = "PostCell"

    private let card = UIView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let metaLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupViews()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupViews() {
        card.layer.cornerRadius = 14
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        bodyLabel.font = .systemFont(ofSize: 14, weight: .regular)
        bodyLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        metaLabel.font = .systemFont(ofSize: 12, weight: .regular)
        metaLabel.translatesAutoresizingMaskIntoConstraints = false

        [titleLabel, bodyLabel, metaLabel].forEach { card.addSubview($0) }

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),

            metaLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 10),
            metaLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            metaLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            metaLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14)
        ])
    }

    func configure(with post: Post, purple: UIColor, cardColor: UIColor) {
        card.backgroundColor = cardColor
        titleLabel.text = post.title
        bodyLabel.text = post.body

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        let dateStr = formatter.localizedString(for: post.createdAt, relativeTo: Date())
        metaLabel.text = "\(post.authorName) • \(dateStr)"
        metaLabel.textColor = purple.withAlphaComponent(0.6)
    }
}
