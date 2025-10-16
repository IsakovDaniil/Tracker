import UIKit

extension UILabel {
    static func ypTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func ypTitleCell(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func ypSubtitleCell(_ text: String? = nil, isHidden: Bool = true) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.ypGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.isHidden = isHidden
        return label
    }
    
    static func makeCharacterLimitLabel() -> UILabel {
        let label = UILabel()
        label.text = R.string.localizable.newEventCharacterLimit()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.ypRed
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func stubLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(
            ofSize: TrackersViewConstants.Typography.stubLabelFontSize,
            weight: .medium
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
