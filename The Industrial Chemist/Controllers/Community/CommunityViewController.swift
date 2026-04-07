//
//  CommunityViewController.swift
//  The Industrial Chemist
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CommunityViewController: UIViewController {

    // MARK: - Constants
    private let bgColor   = UIColor(red: 26/255, green: 1/255, blue: 41/255, alpha: 1.0)
    private let purple    = UIColor(red: 0.74, green: 0.58, blue: 0.98, alpha: 1.0)
    private let cardColor = UIColor(red: 40/255, green: 10/255, blue: 60/255, alpha: 1.0)

    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 20, right: 0)
        tv.register(CommunityCell.self, forCellReuseIdentifier: CommunityCell.reuseID)
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private lazy var emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "No communities yet.\nTap + to create one!"
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

    // MARK: - Data
    private var communities: [Community] = []
    private var joinedIDs: Set<String> = []
    private let db = Firestore.firestore()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        setupNav()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCommunities()
    }

    // MARK: - Setup
    private func setupNav() {
        title = "Communities"
        navigationController?.navigationBar.prefersLargeTitles = false

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bgColor
        appearance.titleTextAttributes = [.foregroundColor: purple]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        let plusButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(createCommunityTapped)
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
    private func fetchCommunities() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        activityIndicator.startAnimating()
        emptyLabel.isHidden = true

        db.collection("communities").order(by: "createdAt", descending: true).getDocuments { [weak self] snap, error in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()

            if let error = error {
                print("Error fetching communities: \(error)")
                return
            }

            var fetched = snap?.documents.compactMap { doc in
                Community(id: doc.documentID, data: doc.data())
            } ?? []

            // Check which ones the user has joined
            let group = DispatchGroup()
            for i in fetched.indices {
                group.enter()
                self.db.collection("communities").document(fetched[i].id)
                    .collection("members").document(uid).getDocument { memberDoc, _ in
                    if memberDoc?.exists == true {
                        fetched[i].isJoined = true
                        self.joinedIDs.insert(fetched[i].id)
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                // Sort: joined communities first
                self.communities = fetched.sorted { $0.isJoined && !$1.isJoined }
                self.tableView.reloadData()
                self.emptyLabel.isHidden = !self.communities.isEmpty
            }
        }
    }

    // MARK: - Actions
    @objc private func createCommunityTapped() {
        let vc = CreateCommunityViewController()
        vc.onCommunityCreated = { [weak self] in
            self?.fetchCommunities()
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }

    private func toggleJoin(for community: Community, at indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let memberRef = db.collection("communities").document(community.id)
            .collection("members").document(uid)
        let communityRef = db.collection("communities").document(community.id)

        if community.isJoined {
            memberRef.delete()
            communityRef.updateData(["memberCount": FieldValue.increment(Int64(-1))])
            communities[indexPath.row].isJoined = false
            communities[indexPath.row].memberCount -= 1
            joinedIDs.remove(community.id)
        } else {
            memberRef.setData(["joinedAt": FieldValue.serverTimestamp()])
            communityRef.updateData(["memberCount": FieldValue.increment(Int64(1))])
            communities[indexPath.row].isJoined = true
            communities[indexPath.row].memberCount += 1
            joinedIDs.insert(community.id)
        }

        // Re-sort and reload
        communities = communities.sorted { $0.isJoined && !$1.isJoined }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource / Delegate
extension CommunityViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        communities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityCell.reuseID, for: indexPath) as! CommunityCell
        cell.configure(with: communities[indexPath.row], purple: purple, cardColor: cardColor)
        cell.onJoinTapped = { [weak self] in
            guard let self = self else { return }
            self.toggleJoin(for: self.communities[indexPath.row], at: indexPath)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let community = communities[indexPath.row]
        let detailVC = CommunityDetailViewController(community: community)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let community = communities[indexPath.row]
        guard community.createdBy == Auth.auth().currentUser?.uid else { return nil }

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.confirmDeleteCommunity(community, at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func confirmDeleteCommunity(_ community: Community, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Delete Community",
            message: "Are you sure you want to delete \"\(community.name)\"? This cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteCommunity(community, at: indexPath)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func deleteCommunity(_ community: Community, at indexPath: IndexPath) {
        db.collection("communities").document(community.id).delete { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error deleting community: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.communities.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.emptyLabel.isHidden = !self.communities.isEmpty
            }
        }
    }
}

// MARK: - CommunityCell
class CommunityCell: UITableViewCell {
    static let reuseID = "CommunityCell"
    var onJoinTapped: (() -> Void)?

    private let card = UIView()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let memberLabel = UILabel()
    private let joinButton = UIButton(type: .system)

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

        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        descLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        descLabel.numberOfLines = 1
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        memberLabel.font = .systemFont(ofSize: 12, weight: .medium)
        memberLabel.translatesAutoresizingMaskIntoConstraints = false

        joinButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        joinButton.layer.cornerRadius = 10
        joinButton.layer.borderWidth = 1
        joinButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.addTarget(self, action: #selector(joinTapped), for: .touchUpInside)

        [nameLabel, descLabel, memberLabel, joinButton].forEach { card.addSubview($0) }

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            nameLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: joinButton.leadingAnchor, constant: -8),

            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: joinButton.leadingAnchor, constant: -8),

            memberLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 6),
            memberLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            memberLabel.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -12),

            joinButton.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            joinButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            joinButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 70)
        ])
    }

    func configure(with community: Community, purple: UIColor, cardColor: UIColor) {
        card.backgroundColor = cardColor
        nameLabel.text = community.name
        descLabel.text = community.description.isEmpty ? "No description" : community.description
        memberLabel.text = "\(community.memberCount) member\(community.memberCount == 1 ? "" : "s")"
        memberLabel.textColor = purple.withAlphaComponent(0.7)

        if community.isJoined {
            joinButton.setTitle("Joined", for: .normal)
            joinButton.setTitleColor(purple, for: .normal)
            joinButton.layer.borderColor = purple.cgColor
            joinButton.backgroundColor = purple.withAlphaComponent(0.15)
        } else {
            joinButton.setTitle("Join", for: .normal)
            joinButton.setTitleColor(purple, for: .normal)
            joinButton.layer.borderColor = purple.cgColor
            joinButton.backgroundColor = .clear
        }
    }

    @objc private func joinTapped() { onJoinTapped?() }
}
