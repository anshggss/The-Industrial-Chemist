import UIKit

class OnboardingTwoViewController: UIViewController, OnboardingPage {

    weak var delegate: OnboardingNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAdaptiveColors()
    }

    private func setupAdaptiveColors() {
        view.backgroundColor = AppColors.onboardingBackground
        applyStyles(to: view)
    }

    private func applyStyles(to view: UIView) {
        if let label = view as? UILabel {
            label.textColor = AppColors.onboardingOnSurface
        } else if let button = view as? UIButton {
            // Disable configuration to prevent system-shading overrides
            button.configuration = nil
            
            button.setTitle("Continue", for: .normal)
            button.backgroundColor = AppColors.onboardingCardPrimary
            button.setTitleColor(AppColors.onboardingTextPrimary, for: .normal)
            button.layer.cornerRadius = 16
            button.clipsToBounds = true
            
            // Apply Glass Border for Dark Mode
            if traitCollection.userInterfaceStyle == .dark {
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            } else {
                button.layer.borderWidth = 0
            }
        }
        
        view.subviews.forEach { applyStyles(to: $0) }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        delegate?.goToNextPage()
    }
}
