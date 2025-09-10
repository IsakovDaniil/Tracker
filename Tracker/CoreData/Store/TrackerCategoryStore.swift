import Foundation
import CoreData

protocol TrackerCategoryStoreProtocol {
    func addCategory(_ category: TrackerCategory) throws
    func fetchAllCategories() throws -> [TrackerCategory]
    func deleteCategory(witchTitle title: String) throws
    func findOrCreateCategory(with title: String) throws -> TrackerCategoryCoreData
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    
    init(coreDataManager: CoreDataManager) {
        self.context = coreDataManager.context
    }
}

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func addCategory(_ category: TrackerCategory) throws {
        <#code#>
    }
    
    func fetchAllCategories() throws -> [TrackerCategory] {
        <#code#>
    }
    
    func deleteCategory(witchTitle title: String) throws {
        <#code#>
    }
    
    func findOrCreateCategory(with title: String) throws -> TrackerCategoryCoreData {
        <#code#>
    }
    
    
}
