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
    
    init(coreDataManager: CoreDataManager) {
        self.context = coreDataManager.context
    }
}

