import Foundation
import CoreData

// MARK: - TrackerCategoryStoreProtocol
protocol TrackerCategoryStoreProtocol {
    func addCategory(_ category: TrackerCategory) throws
    func fetchAllCategories() throws -> [TrackerCategory]
    func deleteCategory(withTitle title: String) throws
    func findOrCreateCategory(with title: String) throws -> TrackerCategoryCoreData
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategories()
}

// MARK: - TrackerCategoryStore
final class TrackerCategoryStore: NSObject {
    
    // MARK: Properties
    weak var delegate: TrackerCategoryStoreDelegate?
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    // MARK: Init
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
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
            print("Error performing fetch for categories: \(error)")
        }
    }
}

// MARK: - TrackerCategoryStoreProtocol Implementation
extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    
    // MARK: Add Category
    func addCategory(_ category: TrackerCategory) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), category.title)
        
        let count = try context.count(for: request)
        
        guard count == .zero else { return }
        
        let categoryEntity = TrackerCategoryCoreData(context: context)
        categoryEntity.title = category.title
        
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Fetch All Categories
    func fetchAllCategories() throws -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        let categoryEntities = try context.fetch(request)
        
        return categoryEntities.map { entity in
            let trackers = (entity.trackers as? Set<TrackerCoreData>)?.compactMap { trackerEntity in
                return convertToTracker(from: trackerEntity)
            } ?? []
            
            return TrackerCategory(title: entity.title ?? "", trackers: trackers)
        }
    }
    
    // MARK: Delete Category
    func deleteCategory(withTitle title: String) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        
        let categories = try context.fetch(request)
        
        for category in categories {
            context.delete(category)
        }
        
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Find or Create Category
    func findOrCreateCategory(with title: String) throws -> TrackerCategoryCoreData {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
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

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateCategories()
    }
}
