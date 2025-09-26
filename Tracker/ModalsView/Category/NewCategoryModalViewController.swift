import UIKit

final class NewCategoryModalViewController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel = UILabel.ypTitle("Новая категория")
    
    private lazy var titleTextField: UITextField = .makeTitleTextField(
        delegate: self,
        action: #selector(textFieldDidChange)
    )
    
    private lazy var doneButton = UIButton.ypModalSecondaryButton(
        title: "Готово",
        titleColor: .ypWhite,
        backgroundColor: .ypGray,
        target: self,
        action: #selector(doneButtonTapped)
    )
    
    // MARK: - Callback
    var onCategoryAdded: ((String) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        doneButton.isEnabled = false
    }
    
    // MARK: - Setup
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
    
    // MARK: - Private Methods
    private func updateDoneButtonState() {
        let hasText = !(titleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        doneButton.isEnabled = hasText
        doneButton.backgroundColor = hasText ? .ypBlack : .ypGray
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateDoneButtonState()
    }
    
    @objc private func doneButtonTapped() {
        guard let categoryName = titleTextField.text?.trimmingCharacters(in: .whitespaces),
              !categoryName.isEmpty else {
            return
        }
        
        onCategoryAdded?(categoryName)
        
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension NewCategoryModalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if doneButton.isEnabled {
            doneButtonTapped()
        }
        return true
    }
}
