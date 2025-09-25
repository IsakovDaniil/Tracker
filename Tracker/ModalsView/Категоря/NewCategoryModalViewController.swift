import UIKit

final class NewCategoryModalViewController: UIViewController {
    private let titleLabel = UILabel.ypTitle("Новая категория")
    
    private lazy var titleTextField: UITextField = .makeTitleTextField(
        delegate: self,
        action: #selector(textFieldDidChange)
    )
    
    private lazy var doneButton = UIButton.ypAddModalButton(
        title: "Готово",
        target: self,
        action: #selector(doneButtonTapped)
    )
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = NewEventConstants.Layout.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(doneButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
    }
    
    @objc private func doneButtonTapped() {
        
    }
    
}


// MARK: - UITextFieldDelegate
extension NewCategoryModalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
