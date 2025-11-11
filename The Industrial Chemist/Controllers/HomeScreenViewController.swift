//
//  HomeScreenViewController.swift
//  The Industrial Chemist
//
//  Created by user@14 on 10/11/25.
//

import UIKit
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

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
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
        }
    
    @IBOutlet weak var streakHeatmap: UICollectionView!
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


}
