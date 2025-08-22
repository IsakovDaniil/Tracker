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
}
