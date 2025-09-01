import UIKit

enum TrackerCellConstants {
    struct Layout {
        static let cardCornerRadius: CGFloat = 16
        static let cardBorderWidth: CGFloat = 1
        static let cardHeight: CGFloat = 90
        
        static let emojiLabelSize: CGFloat = 24
        static let emojiLabelTopInset: CGFloat = 12
        static let emojiLabelLeadingInset: CGFloat = 12
        static let emojiLabelBackgroundAlpha: CGFloat = 0.3
        
        static let titleLabelLeadingInset: CGFloat = 12
        static let titleLabelTrailingInset: CGFloat = -12
        static let titleLabelBottomInset: CGFloat = -12
        static let titleLabelNumberOfLines: Int = 2
        
        static let counterViewHeight: CGFloat = 58
        static let counterLabelTopInset: CGFloat = 16
        static let counterLabelLeadingInset: CGFloat = 12
        
        static let counterButtonSize: CGFloat = 34
        static let counterButtonTopInset: CGFloat = 8
        static let counterButtonTrailingInset: CGFloat = -12
        static let counterButtonCornerRadius: CGFloat = 17
        static let buttonDisabledAlpha: CGFloat = 0.5
        static let buttonEnabledAlpha: CGFloat = 1.0
    }
    
    struct Typography {
        static let emojiLabelFontSize: CGFloat = 16
        static let emojiLabelWeight: UIFont.Weight = .medium
        
        static let titleLabelFontSize: CGFloat = 12
        static let titleLabelWeight: UIFont.Weight = .medium
        
        static let counterLabelFontSize: CGFloat = 12
        static let counterLabelWeight: UIFont.Weight = .medium
    }
    
    struct Strings {
        static let daySingle = "день"
        static let daysFew = "дня"
        static let daysMany = "дней"
        static let checkmarkSymbol = "checkmark"
        static let plusSymbol = "plus"
    }
}
