import Foundation
import CoreData

protocol TrackerRecordStoreProtocol {
    func addRecord(_ record: TrackerRecord) throws
    func removeRecord(for trackerId: UUID, date: Date) throws
    func fetchAllRecords() throws -> [TrackerRecord]
    func isTrackerCompleted(trackerId: UUID, date: Date) throws -> Bool
    func getCompletionCount(for trackerId: UUID) throws -> Int
}

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    private let fetchRequestSimple: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
    
    init(coreDataManager: CoreDataManager) {
        self.context = coreDataManager.context
    }
}

extension TrackerRecordStore: TrackerRecordStoreProtocol {
    func addRecord(_ record: TrackerRecord) throws {
        let recordEntity = TrackerRecordCoreData(context: context)
        recordEntity.trackerID = record.trackerID
        recordEntity.date = record.date
        
        try context.save()
    }
    
    func removeRecord(for trackerId: UUID, date: Date) throws {
        let request = fetchRequestSimple
        
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
        
        try context.save()
    }
    
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
    
    func getCompletionCount(for trackerId: UUID) throws -> Int {
            let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "trackerID == %@", trackerId as CVarArg)
            
            return try context.count(for: request)
        }
    
    
}
