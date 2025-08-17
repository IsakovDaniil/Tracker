import UIKit

final class MainTabBarController: UITabBarController {
    
    private lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupConstraints()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = UIColor.ypWhite
        tabBar.tintColor = UIColor.ypBlue
        tabBar.unselectedItemTintColor = UIColor.ypGray
        tabBar.addSubview(topLine)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: tabBar.topAnchor),
            view.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            view.heightAnchor.constraint(equalToConstant: 1)
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

