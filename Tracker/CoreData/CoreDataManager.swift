import CoreData

final class CoreDataManager {
    private var modelName = "TrackerModel"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Ошибка при загрузке Core Data: \(error)")
            }
        })
        return container
    }()
}
