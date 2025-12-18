import UIKit

class OnboardingTwoViewController: UIViewController, OnboardingPage {

    weak var delegate: OnboardingNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        delegate?.goToNextPage()
    }
}
