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
    
    init(coreDataManager: CoreDataManager) {
        self.context = coreDataManager.context
    }
}

extension TrackerStore: TrackerStoreProtocol {
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        // Не забыить про нахождение и создание категории
        
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.colorHex = uiColorMarshalling.hexString(from: tracker.color)
        trackerEntity.isHabit = tracker.isHabit
        trackerEntity.schedule = tracker.schedule as NSObject
        
        // Не забыть связать с категорией
        try context.save()
    }
    
    func fetchAllTrackers() throws -> [Tracker] {
        
    }
    
    func deleteTracker(withId id: UUID) throws {
        <#code#>
    }
    
    func updateTracker(_ tracker: Tracker) throws {
        <#code#>
    }
    
    
}

