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
    private var community: Community
    private var posts: [Post] = []
    private var likedPostIDs: Set<String> = []
    private var isMember: Bool
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

    // Non-member locked view
    private lazy var lockedView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - Init
    init(community: Community) {
        self.community = community
        self.isMember = community.isJoined
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        setupNav()
        setupLayout()
        setupLockedView()

        if isMember {
            fetchPosts()
        } else {
            showLockedState()
        }
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

        updateNavButton()
    }

    private func updateNavButton() {
        if isMember {
            let plusButton = UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .plain,
                target: self,
                action: #selector(createPostTapped)
            )
            plusButton.tintColor = purple
            navigationItem.rightBarButtonItem = plusButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(activityIndicator)
        view.addSubview(lockedView)

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
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            lockedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lockedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lockedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lockedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupLockedView() {
        let lockIcon = UIImageView(image: UIImage(systemName: "lock.fill"))
        lockIcon.tintColor = purple.withAlphaComponent(0.5)
        lockIcon.contentMode = .scaleAspectFit
        lockIcon.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Members Only"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Join this community to view and create posts"
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.55)
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let joinButton = UIButton(type: .system)
        joinButton.setTitle("Join Community", for: .normal)
        joinButton.setTitleColor(bgColor, for: .normal)
        joinButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        joinButton.backgroundColor = purple
        joinButton.layer.cornerRadius = 14
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.addTarget(self, action: #selector(joinFromLockedView), for: .touchUpInside)

        [lockIcon, titleLabel, subtitleLabel, joinButton].forEach { lockedView.addSubview($0) }

        NSLayoutConstraint.activate([
            lockIcon.centerXAnchor.constraint(equalTo: lockedView.centerXAnchor),
            lockIcon.centerYAnchor.constraint(equalTo: lockedView.centerYAnchor, constant: -80),
            lockIcon.widthAnchor.constraint(equalToConstant: 56),
            lockIcon.heightAnchor.constraint(equalToConstant: 56),

            titleLabel.topAnchor.constraint(equalTo: lockIcon.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: lockedView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: lockedView.trailingAnchor, constant: -32),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: lockedView.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: lockedView.trailingAnchor, constant: -40),

            joinButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            joinButton.centerXAnchor.constraint(equalTo: lockedView.centerXAnchor),
            joinButton.widthAnchor.constraint(equalToConstant: 200),
            joinButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Locked / Unlocked State
    private func showLockedState() {
        tableView.isHidden = true
        emptyLabel.isHidden = true
        lockedView.isHidden = false
    }

    private func showMemberState() {
        lockedView.isHidden = true
        tableView.isHidden = false
        updateNavButton()
        fetchPosts()
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

                if let error = error {
                    self.activityIndicator.stopAnimating()
                    print("Error fetching posts: \(error)")
                    return
                }

                let fetchedPosts = snap?.documents.compactMap {
                    Post(id: $0.documentID, data: $0.data())
                } ?? []

                self.fetchLikeStates(for: fetchedPosts)
            }
    }

    private func fetchLikeStates(for fetchedPosts: [Post]) {
        guard let uid = Auth.auth().currentUser?.uid, !fetchedPosts.isEmpty else {
            self.activityIndicator.stopAnimating()
            self.posts = fetchedPosts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.emptyLabel.isHidden = !self.posts.isEmpty
            }
            return
        }

        let group = DispatchGroup()
        var liked: Set<String> = []

        for post in fetchedPosts {
            group.enter()
            db.collection("communities").document(community.id)
                .collection("posts").document(post.id)
                .collection("likes").document(uid)
                .getDocument { doc, _ in
                    if doc?.exists == true { liked.insert(post.id) }
                    group.leave()
                }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.posts = fetchedPosts
            self.likedPostIDs = liked
            self.tableView.reloadData()
            self.emptyLabel.isHidden = !self.posts.isEmpty
        }
    }

    // MARK: - Like
    private func toggleLike(for post: Post, at indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let likeRef = db.collection("communities").document(community.id)
            .collection("posts").document(post.id)
            .collection("likes").document(uid)
        let postRef = db.collection("communities").document(community.id)
            .collection("posts").document(post.id)

        if likedPostIDs.contains(post.id) {
            likeRef.delete()
            postRef.updateData(["likeCount": FieldValue.increment(Int64(-1))])
            likedPostIDs.remove(post.id)
            posts[indexPath.row].likeCount = max(0, posts[indexPath.row].likeCount - 1)
        } else {
            likeRef.setData(["likedAt": FieldValue.serverTimestamp()])
            postRef.updateData(["likeCount": FieldValue.increment(Int64(1))])
            likedPostIDs.insert(post.id)
            posts[indexPath.row].likeCount += 1
        }

        tableView.reloadRows(at: [indexPath], with: .none)
    }

    // MARK: - Actions
    @objc private func createPostTapped() {
        let vc = CreatePostViewController(communityID: community.id)
        vc.onPostCreated = { [weak self] in self?.fetchPosts() }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }

    @objc private func joinFromLockedView() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let memberRef = db.collection("communities").document(community.id)
            .collection("members").document(uid)
        let communityRef = db.collection("communities").document(community.id)

        memberRef.setData(["joinedAt": FieldValue.serverTimestamp()]) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error joining community: \(error)")
                return
            }
            communityRef.updateData(["memberCount": FieldValue.increment(Int64(1))])
            self.isMember = true
            self.community.isJoined = true
            DispatchQueue.main.async { self.showMemberState() }
        }
    }
}

// MARK: - UITableViewDataSource / Delegate
extension CommunityDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.configure(with: post, purple: purple, cardColor: cardColor,
                       isLiked: likedPostIDs.contains(post.id))
        cell.onLikeTapped = { [weak self] in
            guard let self = self else { return }
            self.toggleLike(for: self.posts[indexPath.row], at: indexPath)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - PostCell
class PostCell: UITableViewCell {
    static let reuseID = "PostCell"
    var onLikeTapped: (() -> Void)?

    private let card = UIView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let metaLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    private let likeCountLabel = UILabel()

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

        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)

        likeCountLabel.font = .systemFont(ofSize: 13, weight: .medium)
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false

        [titleLabel, bodyLabel, metaLabel, likeButton, likeCountLabel].forEach { card.addSubview($0) }

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

            likeButton.topAnchor.constraint(equalTo: metaLabel.bottomAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            likeButton.widthAnchor.constraint(equalToConstant: 28),
            likeButton.heightAnchor.constraint(equalToConstant: 28),
            likeButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),

            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 4)
        ])
    }

    func configure(with post: Post, purple: UIColor, cardColor: UIColor, isLiked: Bool) {
        card.backgroundColor = cardColor
        titleLabel.text = post.title
        bodyLabel.text = post.body

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        let dateStr = formatter.localizedString(for: post.createdAt, relativeTo: Date())
        metaLabel.text = "\(post.authorName) • \(dateStr)"
        metaLabel.textColor = purple.withAlphaComponent(0.6)

        let heartImage = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeButton.setImage(heartImage, for: .normal)
        likeButton.tintColor = isLiked ? UIColor.systemRed : purple.withAlphaComponent(0.7)

        likeCountLabel.text = post.likeCount > 0 ? "\(post.likeCount)" : ""
        likeCountLabel.textColor = isLiked ? UIColor.systemRed : purple.withAlphaComponent(0.7)
    }

    @objc private func likeTapped() { onLikeTapped?() }
}
