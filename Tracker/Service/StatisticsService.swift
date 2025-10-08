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
        var bestStreak = 0
        var perfectDays = 0
        var completedTrackers = 0
        var averagePerDay = 0
        
        do {
            let trackers = try trackerStore.fetchAllTrackers()
            let records = try recordStore.fetchAllRecords()

            var recordsByDate: [Date: [TrackerRecord]] = [:]
            for record in records {
                let date = calendar.startOfDay(for: record.date)
                recordsByDate[date, default: []].append(record)
            }
            
            completedTrackers = records.count
            
            var currentStreak = 0
            let allDates = recordsByDate.keys.sorted()
            for date in allDates {
                let weekday = Weekday(rawValue: calendar.component(.weekday, from: date)) ?? .sunday
                let scheduledTrackers = trackers.filter { tracker in
                    tracker.isHabit ? tracker.schedule.contains(weekday) : true
                }
                
                let recordsForDate = recordsByDate[date] ?? []
                let completedTrackerIds = Set(recordsForDate.map { $0.trackerID })
                let scheduledTrackerIds = Set(scheduledTrackers.map { $0.id })
                
                let isPerfectDay = !scheduledTrackers.isEmpty && scheduledTrackerIds.isSubset(of: completedTrackerIds)
                
                if isPerfectDay {
                    perfectDays += 1
                    currentStreak += 1
                    bestStreak = max(bestStreak, currentStreak)
                } else {
                    currentStreak = .zero
                }
            }
            
            if !allDates.isEmpty {
                let totalDays = allDates.count
                averagePerDay = completedTrackers / totalDays
            }
            
        } catch {
            print("Error calculating statistics: \(error)")
            return Statistics.zero
        }
        
        return Statistics(
            bestStreak: bestStreak,
            perfectDays: perfectDays,
            completedTrackers: completedTrackers,
            averagePerDay: averagePerDay
        )
    }
}
