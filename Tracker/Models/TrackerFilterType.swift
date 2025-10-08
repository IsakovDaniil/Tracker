import Foundation

enum TrackerFilterType: Int, CaseIterable {
    case allTrackers = 0
    case todayTrackers = 1
    case completed = 2
    case notCompleted = 3
    
    var title: String {
        switch self {
        case .allTrackers:
            return "Все трекеры"
        case .todayTrackers:
            return "Трекеры на сегодня"
        case .completed:
            return "Завершенные"
        case .notCompleted:
            return "Не завершенные"
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
