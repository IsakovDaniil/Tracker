import Foundation
import CoreData

protocol TrackerStoreProtocol {
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws
    func fetchAllTrackers() throws -> [Tracker]
    func deleteTracker(withId id: UUID) throws
    func updateTracker(_ tracker: Tracker) throws
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private static let fetchRequestSimple: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
    
    init(coreDataManager: CoreDataManager) {
        self.context = coreDataManager.context
    }
}

extension TrackerStore: TrackerStoreProtocol {
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        let categoryStore = TrackerCategoryStore(coreDataManager: CoreDataManager())
        let categoryEntity = try categoryStore.findOrCreateCategory(with: categoryTitle)
        
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.colorHex = uiColorMarshalling.hexString(from: tracker.color)
        trackerEntity.isHabit = tracker.isHabit
        trackerEntity.schedule = tracker.schedule as NSObject
        trackerEntity.category = categoryEntity
        
        try context.save()
    }
    
    func fetchAllTrackers() throws -> [Tracker] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let trackerEntities = try context.fetch(request)
        
        return trackerEntities.compactMap { entity in
            return convertToTracker(from: entity)
        }
    }
    
    func deleteTracker(withId id: UUID) throws {
        <#code#>
    }
    
    func updateTracker(_ tracker: Tracker) throws {
        <#code#>
    }
    
    private func convertToTracker(from entity: TrackerCoreData) -> Tracker? {
            guard let id = entity.id,
                  let name = entity.name,
                  let emoji = entity.emoji,
                  let colorHex = entity.colorHex,
                  let schedule = entity.schedule as? [Weekday] else {
                return nil
            }
            
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

