import UIKit

class OnboardingFourViewController: UIViewController, OnboardingPage {

    weak var delegate: OnboardingNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continueButtonPressed(_ sender: UIButton) {
        delegate?.finishOnboarding()
    }
}
