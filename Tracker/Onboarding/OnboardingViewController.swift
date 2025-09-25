import UIKit

class OnboardingViewController: UIPageViewController {
    
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
    
    private lazy var pages: [UIViewController] = {
        [
            OnboardingPageViewController(imageName: "OnbordingBlue", text: "Отслеживайте только то, что хотите"),
            OnboardingPageViewController(imageName: "OnbordingRed", text: "Даже если это не литры воды и йога"),
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @objc private func getStaredButtonTapped() {
        
    }
    
}
