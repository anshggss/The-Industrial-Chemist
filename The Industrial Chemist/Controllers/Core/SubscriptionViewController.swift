//
//  SubscriptionViewController.swift
//  The Industrial Chemist
//
//  Presents subscription options and handles purchase flow
//

import UIKit
import StoreKit

final class SubscriptionViewController: UIViewController {

    // MARK: - Properties
    private var products: [SKProduct] = []
    private var selectedProduct: SKProduct?
    private let subscriptionManager = SubscriptionManager.shared

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white.withAlphaComponent(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "crown.fill")
        iv.tintColor = UIColor(hex: "#FFD700")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Unlock Premium"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get unlimited access to all experiments"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let featuresStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let subscriptionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subscribe Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(hex: "#FFD700")
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore Purchases", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "By subscribing, you agree to our Terms of Service and Privacy Policy"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 48/255, green: 16/255, blue: 72/255, alpha: 1)
        setupUI()
        setupActions()
        loadProducts()
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(closeButton)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(featuresStackView)
        contentView.addSubview(subscriptionStackView)
        contentView.addSubview(purchaseButton)
        contentView.addSubview(restoreButton)
        contentView.addSubview(termsLabel)
        contentView.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            closeButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            iconImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            featuresStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            featuresStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            featuresStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            subscriptionStackView.topAnchor.constraint(equalTo: featuresStackView.bottomAnchor, constant: 40),
            subscriptionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subscriptionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            purchaseButton.topAnchor.constraint(equalTo: subscriptionStackView.bottomAnchor, constant: 30),
            purchaseButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            purchaseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            purchaseButton.heightAnchor.constraint(equalToConstant: 50),

            restoreButton.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 16),
            restoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            termsLabel.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 20),
            termsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            termsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            termsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),

            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: subscriptionStackView.centerYAnchor)
        ])

        setupFeatures()
    }

    private func setupFeatures() {
        let features = [
            ("checkmark.circle.fill", "Unlock all experiments instantly"),
            ("infinity.circle.fill", "Unlimited access to all content"),
            ("star.circle.fill", "Priority customer support"),
            ("arrow.clockwise.circle.fill", "Cancel anytime")
        ]

        for (icon, text) in features {
            let featureView = createFeatureView(icon: icon, text: text)
            featuresStackView.addArrangedSubview(featureView)
        }
    }

    private func createFeatureView(icon: String, text: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor(hex: "#FFD700")
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(iconView)
        container.addSubview(label)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        purchaseButton.addTarget(self, action: #selector(purchaseTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
    }

    // MARK: - Product Loading

    private func loadProducts() {
        loadingIndicator.startAnimating()
        subscriptionStackView.isHidden = true

        subscriptionManager.loadProducts { [weak self] success, loadedProducts in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()

                if success, let products = loadedProducts, !products.isEmpty {
                    self.products = products
                    self.selectedProduct = products.first
                    self.displayProducts()
                    self.subscriptionStackView.isHidden = false
                } else {
                    self.showError("Unable to load subscription options. Please try again later.")
                }
            }
        }
    }

    private func displayProducts() {
        // Clear existing views
        subscriptionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for product in products {
            let productView = createProductView(for: product)
            subscriptionStackView.addArrangedSubview(productView)
        }

        // Auto-select first product
        if let firstProduct = products.first {
            selectedProduct = firstProduct
            updateSelection()
        }
    }

    private func createProductView(for product: SKProduct) -> UIView {
        let container = UIView()
        container.tag = products.firstIndex(of: product) ?? 0
        container.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.clear.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(productViewTapped(_:)))
        container.addGestureRecognizer(tapGesture)

        let periodLabel = UILabel()
        periodLabel.text = subscriptionManager.getSubscriptionPeriod(for: product)
        periodLabel.font = .systemFont(ofSize: 18, weight: .bold)
        periodLabel.textColor = .white
        periodLabel.translatesAutoresizingMaskIntoConstraints = false

        let priceLabel = UILabel()
        priceLabel.text = subscriptionManager.getFormattedPrice(for: product)
        priceLabel.font = .systemFont(ofSize: 24, weight: .bold)
        priceLabel.textColor = UIColor(hex: "#FFD700")
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = product.localizedDescription
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = .white.withAlphaComponent(0.7)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let checkmarkView = UIImageView()
        checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkView.tintColor = UIColor(hex: "#FFD700")
        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.isHidden = true
        checkmarkView.tag = 999 // Special tag for checkmark

        container.addSubview(periodLabel)
        container.addSubview(priceLabel)
        container.addSubview(descriptionLabel)
        container.addSubview(checkmarkView)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),

            periodLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            periodLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),

            priceLabel.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),

            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: checkmarkView.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),

            checkmarkView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            checkmarkView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 28),
            checkmarkView.heightAnchor.constraint(equalToConstant: 28)
        ])

        return container
    }

    private func updateSelection() {
        for (index, view) in subscriptionStackView.arrangedSubviews.enumerated() {
            let isSelected = products[safe: index] == selectedProduct
            view.layer.borderColor = isSelected ? UIColor(hex: "#FFD700").cgColor : UIColor.clear.cgColor

            if let checkmark = view.viewWithTag(999) {
                checkmark.isHidden = !isSelected
            }
        }
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func productViewTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view,
              let index = subscriptionStackView.arrangedSubviews.firstIndex(of: view),
              let product = products[safe: index] else {
            return
        }

        selectedProduct = product
        updateSelection()
    }

    @objc private func purchaseTapped() {
        guard let product = selectedProduct else {
            showError("Please select a subscription plan")
            return
        }

        guard subscriptionManager.canMakePayments else {
            showError("Purchases are disabled on this device")
            return
        }

        purchaseButton.isEnabled = false
        purchaseButton.setTitle("Processing...", for: .normal)

        subscriptionManager.purchase(product: product) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.purchaseButton.isEnabled = true
                self?.purchaseButton.setTitle("Subscribe Now", for: .normal)

                if success {
                    self?.showSuccess("Welcome to Premium! 🎉")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self?.dismiss(animated: true)
                    }
                } else {
                    let message = error?.localizedDescription ?? "Purchase failed. Please try again."
                    self?.showError(message)
                }
            }
        }
    }

    @objc private func restoreTapped() {
        restoreButton.isEnabled = false

        subscriptionManager.restorePurchases { [weak self] success, error in
            DispatchQueue.main.async {
                self?.restoreButton.isEnabled = true

                if success {
                    self?.showSuccess("Purchases restored successfully!")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self?.dismiss(animated: true)
                    }
                } else {
                    let message = error?.localizedDescription ?? "No purchases found to restore."
                    self?.showError(message)
                }
            }
        }
    }

    // MARK: - Alerts

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Array Safe Subscript

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
