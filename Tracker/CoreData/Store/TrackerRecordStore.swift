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
        <#code#>
    }
    
    func fetchAllRecords() throws -> [TrackerRecord] {
        <#code#>
    }
    
    func isTrackerCompleted(trackerId: UUID, date: Date) throws -> Bool {
        <#code#>
    }
    
    func getCompletionCount(for trackerId: UUID) throws -> Int {
        <#code#>
    }
    
    
}
