import UIKit
import SwiftUI

class StreakCalendarContainerView: UIView {

    private var hostingController: UIHostingController<StreakCalendarView>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Start with empty data, will load from Firebase
        let calendarView = StreakCalendarView(
            activeDays: [],
            freezeDays: []
        )

        let host = UIHostingController(rootView: calendarView)
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(host.view)
        hostingController = host

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: topAnchor),
            host.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // Load real login data from Firebase
        loadLoginData()

        // Listen for login date updates and refresh calendar
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLoginDateUpdate),
            name: ExperienceManager.loginDateUpdatedNotification,
            object: nil
        )
    }

    @objc private func handleLoginDateUpdate() {
        loadLoginData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func loadLoginData() {
        let calendar = Calendar.current
        let now = Date()
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)

        ExperienceManager.shared.getLoginDaysForMonth(year: year, month: month) { [weak self] loginDays in
            DispatchQueue.main.async {
                // Update the SwiftUI view with real data
                let updatedView = StreakCalendarView(
                    activeDays: loginDays,
                    freezeDays: []  // No freeze days for now
                )

                self?.hostingController?.rootView = updatedView
            }
        }
    }
}
