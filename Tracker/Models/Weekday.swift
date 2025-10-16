import Foundation

enum Weekday: Int, CaseIterable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var localizedName: String {
        switch self {
        case .monday:
            return R.string.localizable.weekdayMondayFull()
        case .tuesday:
            return R.string.localizable.weekdayTuesdayFull()
        case .wednesday:
            return R.string.localizable.weekdayWednesdayFull()
        case .thursday:
            return R.string.localizable.weekdayThursdayFull()
        case .friday:
            return R.string.localizable.weekdayFridayFull()
        case .saturday:
            return R.string.localizable.weekdaySaturdayFull()
        case .sunday:
            return R.string.localizable.weekdaySundayFull()
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return R.string.localizable.weekdayMondayShort()
        case .tuesday:
            return R.string.localizable.weekdayTuesdayShort()
        case .wednesday:
            return R.string.localizable.weekdayWednesdayShort()
        case .thursday:
            return R.string.localizable.weekdayThursdayShort()
        case .friday:
            return R.string.localizable.weekdayFridayShort()
        case .saturday:
            return R.string.localizable.weekdaySaturdayShort()
        case .sunday:
            return R.string.localizable.weekdaySundayShort()
        }
    }
}
