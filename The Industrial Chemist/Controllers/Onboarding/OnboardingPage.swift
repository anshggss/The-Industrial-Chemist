//
//  OnBoardingPage.swift
//  The Industrial Chemist
//
//  Created by admin25 on 19/11/25.
//

import UIKit

protocol OnboardingNavigationDelegate: AnyObject {
    func goToNextPage()
    func finishOnboarding()
}

protocol OnboardingPage: AnyObject {
    var delegate: OnboardingNavigationDelegate? { get set }
}
