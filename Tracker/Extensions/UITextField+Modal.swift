import UIKit

extension UITextField {
    static func ypAddModalTextField() -> UITextField {
        let textField = UITextField()
        textField.textColor = UIColor.ypBlack
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 15
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing

//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0))
//        textField.leftView = paddingView
//        textField.leftViewMode = .always

        return textField
    }
}
