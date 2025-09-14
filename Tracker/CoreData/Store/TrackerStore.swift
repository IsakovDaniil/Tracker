import Foundation
import CoreData

// MARK: - TrackerStoreProtocol
protocol TrackerStoreProtocol {
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws
    func fetchAllTrackers() throws -> [Tracker]
    func deleteTracker(withId id: UUID) throws
    func updateTracker(_ tracker: Tracker) throws
}

// MARK: - TrackerStoreDelegate
protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTrackers()
}

// MARK: - TrackerStore
final class TrackerStore: NSObject {
    
    // MARK: Properties
    weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private static let fetchRequestSimple: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    // MARK: Init
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: Setup
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Error performing fetch: \(error)")
        }
    }
}

// MARK: - TrackerStoreProtocol Implementation
extension TrackerStore: TrackerStoreProtocol {
    
    // MARK: Add Tracker
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        let categoryStore = TrackerCategoryStore(context: context)
        let categoryEntity = try categoryStore.findOrCreateCategory(with: categoryTitle)
        
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.colorHex = uiColorMarshalling.hexString(from: tracker.color)
        trackerEntity.isHabit = tracker.isHabit
        trackerEntity.schedule = tracker.schedule as NSObject
        trackerEntity.category = categoryEntity
        
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Fetch All Trackers
    func fetchAllTrackers() throws -> [Tracker] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let trackerEntities = try context.fetch(request)
        
        return trackerEntities.compactMap { entity in
            return convertToTracker(from: entity)
        }
    }
    
    // MARK: Delete Tracker
    func deleteTracker(withId id: UUID) throws {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let trackers = try context.fetch(request)
        for tracker in trackers {
            context.delete(tracker)
        }
        
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Update Tracker
    func updateTracker(_ tracker: Tracker) throws {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        guard let trackerEntity = try context.fetch(request).first else {
            throw NSError(domain: "TrackerStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Трекер не найден"])
        }
        
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.colorHex = uiColorMarshalling.hexString(from: tracker.color)
        trackerEntity.isHabit = tracker.isHabit
        trackerEntity.schedule = tracker.schedule as NSObject
        
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: - Helpers
    func convertToTracker(from entity: TrackerCoreData) -> Tracker? {
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

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackers()
    }
}
