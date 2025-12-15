import UIKit

class StreakViewController: UIViewController {

    @IBOutlet weak var flameImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        animateFlame()
    }

    private func animateFlame() {
        // Scale animation (pulse)
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 1.08
        scale.duration = 0.9
        scale.autoreverses = true
        scale.repeatCount = .infinity
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // Opacity flicker (very subtle)
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1.0
        opacity.toValue = 0.85
        opacity.duration = 0.9
        opacity.autoreverses = true
        opacity.repeatCount = .infinity

        // Group both animations
        let group = CAAnimationGroup()
        group.animations = [scale, opacity]
        group.duration = 0.9
        group.repeatCount = .infinity

        flameImageView.layer.add(group, forKey: "flamePulse")
    }
}
