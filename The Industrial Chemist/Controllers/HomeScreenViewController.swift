//
//  HomeScreenViewController.swift
//  The Industrial Chemist
//

import UIKit
import FSCalendar

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        var r, g, b: CGFloat
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

class HomeScreenViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    // Start Experiment Button
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupProgressBar()
        setupCalendar()
    }

    // MARK: - PROGRESS BAR SETUP
    func setupProgressBar() {
        progressView.progress = 0.0
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 6)
        
        progressView.progressTintColor = UIColor(hex: "9E87B3")
        progressView.trackTintColor = UIColor.lightGray
        
        let cornerRadius = 6.0
        progressView.layer.cornerRadius = CGFloat(cornerRadius)
        progressView.clipsToBounds = true
        
        if let sublayer = progressView.layer.sublayers?.last {
            sublayer.cornerRadius = CGFloat(cornerRadius)
            sublayer.masksToBounds = true
        }
        
        progressView.setProgress(0.6, animated: true)
    }
    
    
    // MARK: - CALENDAR SETUP
    func setupCalendar() {
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scope = .month
        calendarView.appearance.headerDateFormat = "MMMM yyyy"
        calendarView.appearance.todayColor = UIColor(hex: "9E87B3")
        calendarView.appearance.selectionColor = .systemBlue
    }
    
    
    // MARK: - FSCalendar Delegates
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        print("Selected date:", formatter.string(from: date))
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let eventDates = ["2025-11-10", "2025-11-13", "2025-12-01"]
        let dateString = dateFormatter.string(from: date)
        
        return eventDates.contains(dateString) ? 1 : 0
    }
    
    
    @IBAction func experimentButtonPressed(_ sender: UIButton) {
        // go to learn page
    }
    
    // MARK: - Experiment Button


}

