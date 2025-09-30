import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let coreDataManager = CoreDataManager.shared
    private let userDefaultsService = UserDefaultsService.shared
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        if userDefaultsService.isOnboardingCompleted {
            window.rootViewController = MainTabBarController(coreDataManager: coreDataManager)
        } else {
            window.rootViewController = OnboardingViewController()
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        coreDataManager.saveContext()
    }
}
