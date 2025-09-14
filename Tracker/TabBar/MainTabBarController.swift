import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties
    private let coreDataManager: CoreDataManager
    
    // MARK: - Constants
    private enum TabBarConstants {
        static let topLineHeight: CGFloat = 1
        static let trackersTitle = "Трекеры"
        static let statisticsTitle = "Статистика"
        static let trackersTag = 0
        static let statisticsTag = 1
    }
    
    // MARK: - Init
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let trackersVC = TrackersViewController(coreDataManager: coreDataManager)
        let firstVC = UINavigationController(rootViewController: trackersVC)
        firstVC.tabBarItem = UITabBarItem(title: TabBarConstants.trackersTitle, image: UIImage.trakers, tag: TabBarConstants.trackersTag)
        
        let statisticsVC = StatisticsViewController(coreDataManager: coreDataManager)
        let secondVC = UINavigationController(rootViewController: statisticsVC)
        secondVC.tabBarItem = UITabBarItem(title: TabBarConstants.statisticsTitle, image: UIImage.stats, tag: TabBarConstants.statisticsTag)
        
        viewControllers = [firstVC, secondVC]
    }
}
