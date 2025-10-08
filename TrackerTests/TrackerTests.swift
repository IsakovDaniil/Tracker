import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }
    
    //MARK: - Date
    private func date() -> Date {
        var comps = DateComponents()
        comps.year = 2000
        comps.month = 2
        comps.day = 15
        comps.hour = 14
        return Calendar.current.date(from: comps)!
    }
    
    // MARK: - Helpers
    private func makeTrackersNavigationController() -> UINavigationController {
        let viewController = TrackersViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        _ = viewController.view

        if let datePicker = viewController.navigationItem.rightBarButtonItem?.customView as? UIDatePicker {
            datePicker.date = date()
            datePicker.sendActions(for: .valueChanged)
        }

        let weekday = Weekday.tuesday
        
        let tracker = Tracker(
            id: UUID(),
            name: "Run",
            color: UIColor.systemRed,
            emoji: "🥇",
            schedule: [weekday],
            isHabit: true,
            isPinned: false
        )

        let category = TrackerCategory(title: "Health", trackers: [tracker])
        
        viewController.addCategoryForTesting(category)

        return navigationController
    }
    
    // MARK: - Snapshot tests
    func testTrackersScreenLight() {
        let nav = makeTrackersNavigationController()
        assertSnapshot(
            of: nav,
            as: .image(traits: UITraitCollection(userInterfaceStyle: .light))
        )
    }
    
    func testTrackersScreenDark() {
        let nav = makeTrackersNavigationController()
        assertSnapshot(
            of: nav,
            as: .image(traits: UITraitCollection(userInterfaceStyle: .dark))
        )
    }
}
