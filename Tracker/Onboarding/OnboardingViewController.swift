import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - UI Elements
    private lazy var getStaredButton = UIButton.ypAddModalButton(
        title: "Вот это технологии!",
        target: self,
        action: #selector(getStaredButtonTapped)
    )
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = pages.count
        pc.currentPage = .zero
        
        pc.currentPageIndicatorTintColor = .ypBlack
        pc.pageIndicatorTintColor = UIColor.ypBlack.withAlphaComponent(0.3)
        
        pc.translatesAutoresizingMaskIntoConstraints = false
        
        return pc
    }()
    
    
    // MARK: - Data
    private lazy var pages: [UIViewController] = {
        [
            OnboardingPageViewController(imageName: "OnboardingBlue", text: "Отслеживайте только \nто, что хотите"),
            OnboardingPageViewController(imageName: "OnboardingRed", text: "Даже если это не литры воды и йога"),
        ]
    }()
    
    // MARK: - Init
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setupView()
        setupConstraints()
        setupInitialPage()
    }
    
    
    // MARK: - Setup
    private func setupView() {
        view.addSubview(getStaredButton)
        view.addSubview(pageControl)
        
        view.bringSubviewToFront(getStaredButton)
        view.bringSubviewToFront(pageControl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            getStaredButton.heightAnchor.constraint(equalToConstant: 60),
            getStaredButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            getStaredButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            getStaredButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: getStaredButton.topAnchor, constant: -24)
        ])
    }
    
    private func setupInitialPage() {
        guard let first = pages.first else { return }
        setViewControllers([first], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func getStaredButtonTapped() {
        UserDefaultsService.shared.isOnboardingCompleted = true
        
        let coreDataManager = CoreDataManager.shared
        let mainTabBarController = MainTabBarController(coreDataManager: coreDataManager)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = mainTabBarController
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= .zero else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
