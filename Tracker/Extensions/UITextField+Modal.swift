import UIKit

extension UITextField {
    static func ypTitleTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor.ypBackground
        textField.layer.cornerRadius = 16
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
