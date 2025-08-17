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
}

