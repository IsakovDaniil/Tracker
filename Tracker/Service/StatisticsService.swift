import Foundation

protocol StatisticsServiceProtocol {
    func calculateStatistics() -> Statistics
}


final class StatisticsService: StatisticsServiceProtocol {
    
    // MARK: - Dependencies
    private let trackerStore: TrackerStore
    private let recordStore: TrackerRecordStore
    private let calendar: Calendar
    
    
    // MARK: - Init
    init(
        trackerStore: TrackerStore = TrackerStore(),
        recordStore: TrackerRecordStore = TrackerRecordStore(),
        calendar: Calendar = .current
    ) {
        self.trackerStore = trackerStore
        self.recordStore = recordStore
        self.calendar = calendar
    }
    
    func calculateStatistics() -> Statistics {
        <#code#>
    }
}
