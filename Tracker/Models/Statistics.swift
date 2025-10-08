import Foundation

struct Statistics {
    let bestStreak: Int
    let perfectDays: Int
    let completedTrackers: Int
    let averagePerDay: Int
    
    static let zero = Statistics(
        bestStreak: .zero,
        perfectDays: .zero,
        completedTrackers: .zero,
        averagePerDay: .zero
    )
}
