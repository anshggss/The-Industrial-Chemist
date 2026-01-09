//
//  UIColor+Hex.swift
//  The Industrial Chemist
//
//  Created by admin25 on 09/01/26.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hex = hex.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)

        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1
        )
    }
}


