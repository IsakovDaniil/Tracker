import UIKit

protocol NewHabitDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, categoryTitle: String)
}

final class NewHabitModalViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: NewHabitDelegate?
    private var selectedDays: [Weekday] = []
    private var selectedCategory: String? = nil
    
    private let defaultColor: UIColor = .ypSelection5
    private let defaultEmoji: String = "😪"
    
    // MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle("Новая привычка")
    
    private lazy var titleTextField: UITextField = .makeTitleTextField(
        delegate: self,
        action: #selector(textFieldDidChange)
    )
    
    private lazy var characterLimitLabel = UILabel.makeCharacterLimitLabel()
    
    private lazy var optionsTableView = UITableView.makeOptionsTableView(
        dataSource: self,
        delegate: self,
        separatorStyle: .singleLine
    )
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var cancelButton = UIButton.ypModalSecondaryButton(
        title: "Отменить",
        titleColor: .ypRed,
        backgroundColor: .clear,
        hasBorder: true,
        target: self,
        action: #selector(cancelButtonTapped)
    )
    
    private lazy var createButton = UIButton.ypModalSecondaryButton(
        title: "Создать",
        titleColor: .ypWhite,
        backgroundColor: .ypGray,
        target: self,
        action: #selector(createButtonTapped)
    )
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        updateCreateButtonState()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(characterLimitLabel)
        view.addSubview(optionsTableView)
        view.addSubview(buttonsStackView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            characterLimitLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            characterLimitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            characterLimitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            characterLimitLabel.heightAnchor.constraint(equalToConstant: 22),
            
            optionsTableView.topAnchor.constraint(equalTo: characterLimitLabel.bottomAnchor, constant: 8),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            optionsTableView.heightAnchor.constraint(equalToConstant: 75 * 2),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Validation
    private func updateCreateButtonState() {
        let isValid = isFormValid()
        
        createButton.isEnabled = isValid
        createButton.backgroundColor = isValid ? .ypBlack : .ypGray
    }
    
    private func isFormValid() -> Bool {
        guard let text = titleTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        
        guard selectedCategory != nil else { return false }
        
        guard !selectedDays.isEmpty else { return false }
        
        return true
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count >= 38 {
            if text.count > 38 {
                textField.text = String(text.prefix(38))
            }
            characterLimitLabel.isHidden = false
        } else {
            characterLimitLabel.isHidden = true
        }
        updateCreateButtonState()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard isFormValid(),
              let title = titleTextField.text?.trimmingCharacters(in: .whitespaces),
              let category = selectedCategory else {
            return
        }
        
        let newTracker = Tracker(
            id: UUID(),
            name: title,
            color: defaultColor,
            emoji: defaultEmoji,
            schedule: selectedDays,
            isHabit: true
        )
        
        delegate?.didCreateTracker(newTracker, categoryTitle: category)
        
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate
extension NewHabitModalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - UITableViewDataSource
extension NewHabitModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.configure(title: "Категория", subtitle: selectedCategory)
        } else {
            let subtitle: String?
            if selectedDays.count == 7 {
                subtitle = "Каждый день"
            } else {
                subtitle = selectedDays.isEmpty ? nil : selectedDays.map { $0.shortName }.joined(separator: ", ")
            }
            cell.configure(title: "Расписание", subtitle: subtitle)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewHabitModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            selectedCategory = "Важные дела"
            optionsTableView.reloadData()
            updateCreateButtonState()
            
        } else if indexPath.row == 1 {
            let scheduleVC = SelectScheduleModalViewController()
            scheduleVC.delegate = self
            scheduleVC.modalPresentationStyle = .formSheet
            present(scheduleVC, animated: true, completion: nil)
        }
    }
}

// MARK: - SelectScheduleDelegate
extension NewHabitModalViewController: SelectScheduleDelegate {
    func didSelectDays(_ days: [Weekday]) {
        selectedDays = days
        optionsTableView.reloadData()
        updateCreateButtonState()
    }
}
