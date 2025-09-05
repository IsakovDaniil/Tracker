import UIKit

extension UITextField {
    static func makeTitleTextField(
        delegate: UITextFieldDelegate,
        action: Selector
    ) -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor.ypBackground
        textField.layer.cornerRadius = 16
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.delegate = delegate
        textField.addTarget(delegate, action: action, for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
