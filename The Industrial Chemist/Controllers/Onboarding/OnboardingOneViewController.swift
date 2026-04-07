import UIKit

class OnboardingOneViewController: UIViewController, OnboardingPage {

    weak var delegate: OnboardingNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continueButtonPressed(_ sender: UIButton) {
        delegate?.goToNextPage()
    }
}
