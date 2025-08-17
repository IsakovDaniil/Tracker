import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - UI Elements
    private lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypTopLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupConstraints()
        setupViewControllers()
    }
    
    // MARK: - Setup Methods
    private func setupTabBar() {
        tabBar.backgroundColor = UIColor.ypWhite
        tabBar.tintColor = UIColor.ypBlue
        tabBar.unselectedItemTintColor = UIColor.ypGray
        tabBar.addSubview(topLine)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: tabBar.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupViewControllers() {
        let firstVC = UINavigationController(rootViewController: TrackersViewController())
        firstVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage.trakers, tag: 0)
        
        let secondVC = UINavigationController(rootViewController: StatisticsViewController())
        secondVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage.stats, tag: 1)
        
        viewControllers = [firstVC, secondVC]
    }
}
