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
    static let fetchRequestSimple: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
    
    init(coreDataManager: CoreDataManager) {
        self.context = coreDataManager.context
    }
}

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func addCategory(_ category: TrackerCategory) throws {
        let categoryEntity = TrackerCategoryCoreData(context: context)
        categoryEntity.title = category.title
        
        try context.save()
    }
    
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
    
    
    func deleteCategory(witchTitle title: String) throws {
        let request = TrackerCategoryStore.fetchRequestSimple
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        
        let categories = try context.fetch(request)
        
        for category in categories {
            context.delete(category)
        }
        
        try context.save()
    }
    
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
