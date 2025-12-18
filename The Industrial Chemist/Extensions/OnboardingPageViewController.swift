import UIKit

class OnboardingPageViewController: UIPageViewController {

    // MARK: - Pages
    lazy var pages: [UIViewController & OnboardingPage] = {
        return [
            OnboardingOneViewController(nibName: "OnboardingOne", bundle: nil),
            OnboardingTwoViewController(nibName: "OnboardingTwo", bundle: nil),
            OnboardingThreeViewController(nibName: "OnboardingThree", bundle: nil), // last page,
            OnboardingFourViewController(nibName: "OnboardingFour", bundle: nil)
        ]
    }()

    private let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        // Give each page the delegate so buttons work
        pages.forEach { $0.delegate = self }

        // Start on page 1
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }

        setupPageControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Hide ONLY the system UIPageControl (the three dots)
        for subview in view.subviews {
            if NSStringFromClass(type(of: subview)) == "UIPageControl" {
                subview.isHidden = true
            }
        }
    }


    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}


// MARK: - UIPageViewController DataSource & Delegate
extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pvc: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(where: { $0 === viewController }),
              idx > 0 else { return nil }
        return pages[idx - 1]
    }

    func pageViewController(_ pvc: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(where: { $0 === viewController }),
              idx < pages.count - 1 else { return nil }
        return pages[idx + 1]
    }

    func pageViewController(_ pvc: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let current = viewControllers?.first,
              let idx = pages.firstIndex(where: { $0 === current }) else { return }
        pageControl.currentPage = idx
    }
}


// MARK: - OnboardingNavigationDelegate
extension OnboardingPageViewController: OnboardingNavigationDelegate {

    // FIXED: use `pages`, not `orderedPages`
    func goToNextPage() {
        guard let currentVC = viewControllers?.first,
              let currentIndex = pages.firstIndex(where: { $0 === currentVC }) else { return }

        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count else { return }

        setViewControllers([pages[nextIndex]], direction: .forward, animated: true)
        pageControl.currentPage = nextIndex
    }

    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "seenOnboarding")

        let main = LogInViewController(nibName: "LogIn", bundle: nil)

        setRootViewController(main, animated: false)
    }

    private func setRootViewController(_ vc: UIViewController, animated: Bool) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }

        window.rootViewController = vc
        window.makeKeyAndVisible()

        if animated {
            UIView.transition(with: window,
                              duration: 0.35,
                              options: .transitionFlipFromRight,
                              animations: nil)
        }
    }
}
