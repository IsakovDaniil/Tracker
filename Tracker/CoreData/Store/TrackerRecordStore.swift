import Foundation
import CoreData

// MARK: - TrackerRecordStoreProtocol
protocol TrackerRecordStoreProtocol {
    func addRecord(_ record: TrackerRecord) throws
    func removeRecord(for trackerId: UUID, date: Date) throws
    func fetchAllRecords() throws -> [TrackerRecord]
    func isTrackerCompleted(trackerId: UUID, date: Date) throws -> Bool
    func getCompletionCount(for trackerId: UUID) throws -> Int
}

// MARK: - TrackerRecordStore
final class TrackerRecordStore: NSObject {
    
    // MARK: Properties
    private let context: NSManagedObjectContext
    private let fetchRequestSimple: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
    
    // MARK: Init
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
}

// MARK: - TrackerRecordStoreProtocol Implementation
extension TrackerRecordStore: TrackerRecordStoreProtocol {
    
    // MARK: Add Record
    func addRecord(_ record: TrackerRecord) throws {
        let recordEntity = TrackerRecordCoreData(context: context)
        recordEntity.trackerID = record.trackerID
        recordEntity.date = record.date
        
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Remove Record
    func removeRecord(for trackerId: UUID, date: Date) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(
            format: "trackerID == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        
        let records = try context.fetch(request)
        for record in records {
            context.delete(record)
        }
        
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: Fetch All Records
    func fetchAllRecords() throws -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let recordEntities = try context.fetch(request)
        
        return recordEntities.compactMap { entity in
            guard let trackerID = entity.trackerID,
                  let date = entity.date else {
                return nil
            }
            
            return TrackerRecord(trackerID: trackerID, date: date)
        }
    }
    
    // MARK: Is Tracker Completed
    func isTrackerCompleted(trackerId: UUID, date: Date) throws -> Bool {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        request.predicate = NSPredicate(
            format: "trackerID == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        
        let count = try context.count(for: request)
        return count > 0
    }
    
    // MARK: Get Completion Count
    func getCompletionCount(for trackerId: UUID) throws -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerID == %@", trackerId as CVarArg)
        
        return try context.count(for: request)
    }
}
