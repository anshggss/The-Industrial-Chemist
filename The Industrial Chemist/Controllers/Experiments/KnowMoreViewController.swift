import UIKit

class KnowMoreViewController: UIViewController {

    // MARK: - Configuration
    // Replace with your actual Anthropic API key
    private let anthropicAPIKey = "ak_2tW3LJ84Y0Id6KE0or54C0w73hC4O"

    // MARK: - Properties
    private let experiment: Experiment

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let responseLabel = UILabel()
    private let errorLabel = UILabel()

    // MARK: - Init
    init(experiment: Experiment) {
        self.experiment = experiment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchKnowMore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.tintColor = UIColor(red: 0.86, green: 0.65, blue: 0.93, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.08, green: 0.04, blue: 0.13, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.08, green: 0.04, blue: 0.13, alpha: 1)
        title = "Know More"

        // Back button colour
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )

        setupScrollView()
        setupHeader()
        setupContent()
    }

    private func setupScrollView() {
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
    }

    private func setupHeader() {
        // Experiment title
        titleLabel.text = experiment.title
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Subtitle
        subtitleLabel.text = "Deep dive powered by AI"
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = UIColor(red: 0.86, green: 0.65, blue: 0.93, alpha: 1)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Sparkle icon badge
        let badgeView = UIView()
        badgeView.backgroundColor = UIColor(red: 0.53, green: 0.27, blue: 0.75, alpha: 0.3)
        badgeView.layer.cornerRadius = 10
        badgeView.translatesAutoresizingMaskIntoConstraints = false

        let sparkleIcon = UIImageView(image: UIImage(systemName: "sparkles"))
        sparkleIcon.tintColor = UIColor(red: 0.86, green: 0.65, blue: 0.93, alpha: 1)
        sparkleIcon.contentMode = .scaleAspectFit
        sparkleIcon.translatesAutoresizingMaskIntoConstraints = false
        badgeView.addSubview(sparkleIcon)

        contentView.addSubview(badgeView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            badgeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            badgeView.widthAnchor.constraint(equalToConstant: 36),
            badgeView.heightAnchor.constraint(equalToConstant: 36),

            sparkleIcon.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            sparkleIcon.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),
            sparkleIcon.widthAnchor.constraint(equalToConstant: 18),
            sparkleIcon.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.topAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    private func setupContent() {
        // Card container
        let cardView = UIView()
        cardView.backgroundColor = UIColor(red: 0.18, green: 0.09, blue: 0.29, alpha: 1)
        cardView.layer.cornerRadius = 20
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        // Activity indicator
        activityIndicator.color = UIColor(red: 0.86, green: 0.65, blue: 0.93, alpha: 1)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        cardView.addSubview(activityIndicator)

        // Loading label
        let loadingLabel = UILabel()
        loadingLabel.text = "Generating insights..."
        loadingLabel.font = .systemFont(ofSize: 14, weight: .medium)
        loadingLabel.textColor = UIColor(red: 0.86, green: 0.65, blue: 0.93, alpha: 0.7)
        loadingLabel.textAlignment = .center
        loadingLabel.tag = 999
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(loadingLabel)

        // Response label
        responseLabel.numberOfLines = 0
        responseLabel.textColor = UIColor(red: 0.9, green: 0.88, blue: 0.95, alpha: 1)
        responseLabel.font = .systemFont(ofSize: 16, weight: .regular)
        responseLabel.isHidden = true
        responseLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(responseLabel)

        // Error label
        errorLabel.numberOfLines = 0
        errorLabel.textColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        errorLabel.font = .systemFont(ofSize: 15)
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            activityIndicator.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),

            loadingLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 12),
            loadingLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -40),

            responseLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            responseLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            responseLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            responseLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),

            errorLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            errorLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            errorLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -40)
        ])
    }

    // MARK: - Navigation
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Claude API

    private func fetchKnowMore() {
        guard let url = URL(string: "https://api.longcat.chat/anthropic/v1/messages") else { return }

        let prompt = """
        You are an expert industrial chemistry educator. Provide a detailed, engaging explanation about the \(experiment.title).

        Cover the following:
        1. **Industrial Importance** – Why this process matters at scale, economic significance, global production figures.
        2. **Chemical Mechanisms** – Step-by-step reaction mechanisms, catalysts used, reaction conditions (temperature, pressure).
        3. **Real-World Applications** – End products and their everyday uses.
        4. **Environmental Impact** – Emissions, sustainability challenges, and modern green chemistry solutions.
        5. **Fascinating Facts** – Surprising or little-known facts about this process.

        Write clearly for a curious student audience. Use plain text only — no markdown headers or bullet symbols.
        Keep the total response under 500 words.
        """

        let body: [String: Any] = [
            "model": "LongCat-Flash-Chat",
            "max_tokens": 700,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(anthropicAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = bodyData

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.handleAPIResponse(data: data, error: error)
            }
        }.resume()
    }

    private func handleAPIResponse(data: Data?, error: Error?) {
        activityIndicator.stopAnimating()
        if let loadingLabel = contentView.viewWithTag(999) {
            loadingLabel.isHidden = true
        }

        if let error = error {
            showError("Network error: \(error.localizedDescription)")
            return
        }

        guard let data = data else {
            showError("No response received.")
            return
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let firstBlock = content.first,
              let text = firstBlock["text"] as? String else {

            // Try to surface API error message
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorObj = json["error"] as? [String: Any],
               let message = errorObj["message"] as? String {
                showError("API error: \(message)")
            } else {
                showError("Could not parse response. Check your API key.")
            }
            return
        }

        responseLabel.text = text
        responseLabel.isHidden = false
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        responseLabel.isHidden = true
    }
}
