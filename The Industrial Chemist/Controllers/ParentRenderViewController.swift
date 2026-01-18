////
////  ParentRenderViewController.swift
////  The Industrial Chemist
////
////  Created by admin25 on 17/12/25.
////
//
//import UIKit
//
//class ParentRenderViewController: UIViewController {
//
//    // MARK: - Outlets
//    @IBOutlet weak var segmentControl: UISegmentedControl!
//    @IBOutlet weak var containerView: UIView!
//
//    // MARK: - Child View Controllers (XIB-based)
//    private lazy var setupVC = SetUpViewController(nibName: "SetUp", bundle: nil)
//    private lazy var theoryVC = TheoryViewController(nibName: "Theory", bundle: nil)
//    private lazy var buildVC = BuildViewController(nibName: "Build", bundle: nil)
//    private lazy var testVC = TestViewController(nibName: "Test", bundle: nil)
//    private lazy var resultsVC = ResultsViewController(nibName: "Results", bundle: nil)
//
//    // MARK: - State
//    private var currentVC: UIViewController?
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        segmentControl.selectedSegmentIndex = 0
//        renderSegment(index: 0)
//    }
//
//    // MARK: - Segmented Control Action
//    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
//        renderSegment(index: sender.selectedSegmentIndex)
//    }
//
//    // MARK: - Conditional Rendering
//    private func renderSegment(index: Int) {
//        let vc: UIViewController
//
//        switch index {
//        case 0:
//            vc = setupVC
//        case 1:
//            vc = theoryVC
//        case 2:
//            vc = buildVC
//        case 3:
//            vc = testVC
//        case 4:
//            vc = resultsVC
//        default:
//            return
//        }
//
//        switchToChild(vc)
//    }
//
//    // MARK: - Child View Controller Handling
//    private func switchToChild(_ vc: UIViewController) {
//        if currentVC === vc { return }   // 👈 important
//
//        removeCurrentChild()
//
//        addChild(vc)
//        containerView.addSubview(vc.view)
//
//        vc.view.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            vc.view.topAnchor.constraint(equalTo: containerView.topAnchor),
//            vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        ])
//
//        vc.didMove(toParent: self)
//        currentVC = vc
//    }
//
//
//    private func removeCurrentChild() {
//        guard let currentVC = currentVC else { return }
//
//        currentVC.willMove(toParent: nil)
//        currentVC.view.removeFromSuperview()
//        currentVC.removeFromParent()
//    }
//}
