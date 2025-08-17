import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = UIColor.ypWhite
        tabBar.tintColor = UIColor.ypBlue
        tabBar.unselectedItemTintColor = UIColor.ypGray
    }
    
    private func setupViewCЙontrollers() {
        let firstVC = UINavigationController(rootViewController: TrackersViewController())
        firstVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage.trakers, tag: 0)
        
        let secondVC = UINavigationController(rootViewController: )
    }
}

