import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coreDataManager: CoreDataManager?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        DaysValueTransformer.register()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        coreDataManager = CoreDataManager()
        
        guard let coreDataManager else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainTabBarController(coreDataManager: coreDataManager)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        coreDataManager?.saveContext()
    }

}

