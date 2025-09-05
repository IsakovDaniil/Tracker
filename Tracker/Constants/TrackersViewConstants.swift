import Foundation

enum TrackersViewConstants {
    struct Layout {
        static let titleLabelLeadingInset: CGFloat = 16
        
        static let searchBarTopInset: CGFloat = 7
        static let searchBarLeadingInset: CGFloat = 10
        static let searchBarTrailingInset: CGFloat = -10
        static let searchBarHeight: CGFloat = 36
        
        static let stubStackTopInset: CGFloat = 230
        static let stubStackSpacing: CGFloat = 8
        
        static let collectionViewTopInset: CGFloat = 24
        static let collectionViewHorizontalInset: CGFloat = 16
        static let collectionViewCellHeight: CGFloat = 148
        static let collectionViewAvailableWidthOffset: CGFloat = 16
        static let collectionViewMinimumInteritemSpacing: CGFloat = 9
        static let collectionViewHeaderHeight: CGFloat = 50
        static let collectionViewSectionBottomInset: CGFloat = 16
        static let zeroInset: CGFloat = 0
    }
    
    struct Typography {
        static let titleLabelFontSize: CGFloat = 34
        static let stubLabelFontSize: CGFloat = 12
    }
    
    struct Strings {
        static let titleText = "Трекеры"
        static let searchBarPlaceholder = "Поиск"
        static let stubLabelText = "Что будем отслеживать?"
        static let trackerCellIdentifier = "TrackerCell"
        static let trackerHeaderViewIdentifier = "TrackerHeaderView"
        static let dateFormat = "dd.MM.yy"
        static let selectedDateMessage = "Выбранная дата: %@"
    }
}
