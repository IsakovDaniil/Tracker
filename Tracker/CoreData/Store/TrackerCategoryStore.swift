import Foundation
import CoreData

// MARK: - TrackerCategoryStoreProtocol
protocol TrackerCategoryStoreProtocol {
    func addCategory(_ category: TrackerCategory) throws
    func fetchAllCategories() throws -> [TrackerCategory]
    func deleteCategory(witchTitle title: String) throws
    func findOrCreateCategory(with title: String) throws -> TrackerCategoryCoreData
}

// MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {
    
    // MARK: Properties
    private let context: NSManagedObjectContext
    static let fetchRequestSimple: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
    
    // MARK: Init
    init(coreDataManager: CoreDataManager) {
        self.context = coreDataManager.context
    }
}

// MARK: - TrackerCategoryStoreProtocol Implementation
extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    
    // MARK: Add Category
    func addCategory(_ category: TrackerCategory) throws {
        let categoryEntity = TrackerCategoryCoreData(context: context)
        categoryEntity.title = category.title
        
        try context.save()
    }
    
    // MARK: Fetch All Categories
    func fetchAllCategories() throws -> [TrackerCategory] {
        let request = TrackerCategoryStore.fetchRequestSimple
        let categoryEntities = try context.fetch(request)
        
        return categoryEntities.map { entity in
            let trackers = (entity.trackers as? Set<TrackerCoreData>)?.compactMap { trackerEntity in
                return convertToTracker(from: trackerEntity)
            } ?? []
            
            return TrackerCategory(title: entity.title ?? "", trackers: trackers)
        }
    }
    
    // MARK: Delete Category
    func deleteCategory(witchTitle title: String) throws {
        let request = TrackerCategoryStore.fetchRequestSimple
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        
        let categories = try context.fetch(request)
        
        for category in categories {
            context.delete(category)
        }
        
        try context.save()
    }
    
    // MARK: Find or Create Category
    func findOrCreateCategory(with title: String) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryStore.fetchRequestSimple
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        
        if let existingCategory = try context.fetch(request).first {
            return existingCategory
        }
        
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.title = title
        
        return newCategory
    }
    
    // MARK: - Helpers
    private func convertToTracker(from entity: TrackerCoreData) -> Tracker? {
        guard let id = entity.id,
              let name = entity.name,
              let emoji = entity.emoji,
              let colorHex = entity.colorHex,
              let schedule = entity.schedule as? [Weekday] else {
            return nil
        }
        
        let uiColorMarshalling = UIColorMarshalling()
        let color = uiColorMarshalling.color(from: colorHex)
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            isHabit: entity.isHabit
        )
    }
}
