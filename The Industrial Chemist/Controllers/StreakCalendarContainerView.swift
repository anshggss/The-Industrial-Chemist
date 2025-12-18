import UIKit
import SwiftUI

class StreakCalendarContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {

        let activeDays: Set<Int> = [12, 13, 14, 15]
        let freezeDays: Set<Int> = [15]

        let calendarView = StreakCalendarView(
            activeDays: activeDays,
            freezeDays: freezeDays
        )

        let host = UIHostingController(rootView: calendarView)
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(host.view)

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: topAnchor),
            host.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
