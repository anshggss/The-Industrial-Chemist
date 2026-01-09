import UIKit

class Leaderboard2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.background

        let leaderboardView = LeaderboardView(frame: view.bounds)
        leaderboardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(leaderboardView)
    }

}
