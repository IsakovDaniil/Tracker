import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Constants
    private enum TabBarConstants {
        static let topLineHeight: CGFloat = 1
        static let trackersTitle = "Трекеры"
        static let statisticsTitle = "Статистика"
        static let trackersTag = 0
        static let statisticsTag = 1
    }
    
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
            topLine.heightAnchor.constraint(equalToConstant: TabBarConstants.topLineHeight)
        ])
    }
    
    private func setupViewControllers() {
        let firstVC = UINavigationController(rootViewController: TrackersViewController())
        firstVC.tabBarItem = UITabBarItem(title: TabBarConstants.trackersTitle, image: UIImage.trakers, tag: TabBarConstants.trackersTag)
        
        let secondVC = UINavigationController(rootViewController: StatisticsViewController())
        secondVC.tabBarItem = UITabBarItem(title: TabBarConstants.statisticsTitle, image: UIImage.stats, tag: TabBarConstants.statisticsTag)
        
        viewControllers = [firstVC, secondVC]
    }
}
