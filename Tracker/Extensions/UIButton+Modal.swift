import UIKit

extension UIButton {
   static func ypAddModalButton(title: String, target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    static func ypModalSecondaryButton(
        title: String,
        titleColor: UIColor,
        backgroundColor: UIColor,
        hasBorder: Bool = false,
        target: Any? = nil,
        action: Selector? = nil
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        
        if hasBorder {
            button.layer.borderWidth = 1
            button.layer.borderColor = titleColor.cgColor
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        
        return button
    }
}
