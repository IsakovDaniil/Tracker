import UIKit

final class NewEventModalViewController: UIViewController {
    //MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle("Новое нерегулярное событие")
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.ypBlack
        textField.backgroundColor = UIColor.ypBackground
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 15
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    // MARK: - Action
    
}
