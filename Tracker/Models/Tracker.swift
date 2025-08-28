import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let isHabit: Bool
    
    init(id: UUID = UUID(), name: String, color: UIColor, emoji: String, schedule: [Weekday], isHabit: Bool) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.isHabit = isHabit
    }
}

