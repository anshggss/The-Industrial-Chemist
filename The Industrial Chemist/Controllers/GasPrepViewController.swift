import UIKit

class GasPrepViewController: UIViewController {

    @IBOutlet weak var prepView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTap()
    }

    private func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonPressed))
        prepView.isUserInteractionEnabled = true
        prepView.addGestureRecognizer(tap)
    }

    @objc func buttonPressed() {
        let setUp = SetUpViewController(nibName: "SetUp", bundle: nil)
        self.navigationController?.pushViewController(setUp, animated: true)
        print("pressed")
    }
}
