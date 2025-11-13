//
//  HomeScreenViewController.swift
//  The Industrial Chemist
//
//  Created by user@14 on 10/11/25.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0.0
            
            // Scale height by 6
            progressView.transform = progressView.transform.scaledBy(x: 1, y: 6)
            
            progressView.progressTintColor = UIColor(hex: "9E87B3")
            progressView.trackTintColor = UIColor.lightGray
            
            // Use consistent corner radius matching scaled height (default height ≈ 2)
            let cornerRadius = 6.0
            
            progressView.layer.cornerRadius = CGFloat(cornerRadius)
            progressView.clipsToBounds = true
                
            if let sublayer = progressView.layer.sublayers?.last {
                sublayer.cornerRadius = CGFloat(cornerRadius)
                sublayer.masksToBounds = true
            }
            
            progressView.setProgress(0.6, animated: true)
        calendarView.dataSource = self
                calendarView.delegate = self
                
                // Optional: Customization
                calendarView.scope = .month // Sets the calendar to month view
                calendarView.appearance.headerDateFormat = "MMMM yyyy" // Custom date format
                calendarView.appearance.todayColor = UIColor(hex: "9E87B3") // Use your theme color for today
                calendarView.appearance.selectionColor = .systemBlue
        }
    
  
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 7
        let leftInset: CGFloat = 8
        let rightInset: CGFloat = 8
        let minimumInteritemSpacing: CGFloat = 4
        let totalSpacing = leftInset + rightInset + (minimumInteritemSpacing * (numberOfItemsPerRow - 1))
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            let dateString = formatter.string(from: date)
            
            print("FSCalendar: Selected date: \(dateString)")
            // Add your logic to handle the selected date here (e.g., loading events)
        }
        
        // MARK: - FSCalendarDataSource (Step 6: Data & Events)

        // Example of adding an event indicator (optional)
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // Replace with actual logic to check for events on the given date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let eventDates = ["2025-11-10", "2025-11-13", "2025-12-01"]
        let dateString = dateFormatter.string(from: date)
        
        if eventDates.contains(dateString) {
            return 1 // Show one dot for dates that have an event
        }
        return 0 // No events
        
    }
    
}
