import Foundation

enum TrackerFilterType: Int, CaseIterable {
    case allTrackers = 0
    case todayTrackers = 1
    case completed = 2
    case notCompleted = 3
    
    var title: String {
        switch self {
        case .allTrackers:
            return R.string.localizable.filterAllTrackers()
        case .todayTrackers:
            return R.string.localizable.filterTodayTrackers()
        case .completed:
            return R.string.localizable.filterCompleted()
        case .notCompleted:
            return R.string.localizable.filterNotCompleted()
        }
    }
    
    var shouldShowCheckmark: Bool {
        switch self {
        case .completed, .notCompleted:
            return true
        case .allTrackers, .todayTrackers:
            return false
        }
    }
}
