import UIKit

enum AppColors {

    // MARK: - App Theme (Locked to Dark)
    // Deep purple (#1A0129)
    static let background = UIColor(hex: "#1A0129")

    // Light lavender (#E6C9FF)
    static let cardPrimary = UIColor(hex: "#E6C9FF")

    // Deep purple (#1A0129) - For text on cardPrimary
    static let textPrimary = UIColor(hex: "#1A0129")

    static let icon = UIColor(hex: "#1A0129")

    // Darker lavender
    static let cardSecondary = UIColor(hex: "#DDB8FF")

    // MARK: - Status Colors
    // Vibrant purple
    static let progress = UIColor(hex: "#9D4EDD")

    // Light purple
    static let progressTrack = UIColor(hex: "#CFA9FF")

    // Medium purple
    static let inProgress = UIColor(hex: "#7B2CBF")

    // Completed (Green-Teal)
    static let completed = UIColor(hex: "#2A9D8F")

    // Locked (Gray)
    static let locked = UIColor(hex: "#9E9E9E")

    // MARK: - Surfaces
    // Very dark purple
    static let surface = UIColor(hex: "#2D0A4A")

    // Light lavender text on surface cards
    static let onSurface = UIColor(hex: "#E6C9FF")

    // MARK: - Onboarding Theme (Adaptive)
    // Dark mode: deep purple (#1A0129) | Light mode: near-white (#F5F0FA)
    static let onboardingBackground = UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(hex: "#1A0129")
            : UIColor(hex: "#F5F0FA")
    }

    // Adaptive Onboarding Button Background
    // Dark mode: semi-transparent-white (Glass base) | Light mode: rich deep-purple (#4A1080)
    static let onboardingCardPrimary = UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.15) 
            : UIColor(hex: "#4A1080")
    }

    // Adaptive Onboarding Button Text
    // Dark mode: white (#FFFFFF) | Light mode: white (#FFFFFF)
    static let onboardingTextPrimary = UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor.white
    }

    // Dark mode: light lavender (#E6C9FF) | Light mode: deep purple (#1A0129)
    static let onboardingOnSurface = UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(hex: "#E6C9FF")
            : UIColor(hex: "#1A0129")
    }
}
