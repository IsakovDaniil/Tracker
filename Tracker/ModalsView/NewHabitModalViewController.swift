import UIKit

protocol NewHabitDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, categoryTitle: String)
    func didCreateEvent(_ event: Tracker, categoryTitle: String)
}

final class NewHabitModalViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: NewHabitDelegate?
    
    private var selectedDays: [Weekday] = []
    private var selectedCategory: String? = nil
    private var selectedColor: UIColor = .white
    private var selectedEmoji: String = ""
    
    private lazy var emojiColorManager: EmojiColorCollectionManager = {
        let manager = EmojiColorCollectionManager()
        manager.delegate = self
        return manager
    }()
    
    // MARK: - UI Elements
    private let titleLabel = UILabel.ypTitle(
        R.string.localizable.newHabitTitle()
    )
    
    private lazy var titleTextField: UITextField = .makeTitleTextField(
        delegate: self,
        action: #selector(textFieldDidChange)
    )
    
    private let characterLimitLabel = UILabel.makeCharacterLimitLabel()
    
    private lazy var optionsTableView = UITableView.makeOptionsTableView(
        dataSource: self,
        delegate: self,
        separatorStyle: .singleLine
    )
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emojiColorManager.configure(collectionView: collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.spacing = NewHabitConstants.Layout.stackSpacing
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var cancelButton = UIButton.ypModalSecondaryButton(
        title: R.string.localizable.commonCancel(),
        titleColor: .ypRed,
        backgroundColor: .clear,
        hasBorder: true,
        target: self,
        action: #selector(cancelButtonTapped)
    )
    
    private lazy var createButton = UIButton.ypModalSecondaryButton(
        title: R.string.localizable.commonCreate(),
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
        view.layer.cornerRadius = NewHabitConstants.Layout.viewCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .ypWhite
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(characterLimitLabel)
        view.addSubview(optionsTableView)
        view.addSubview(collectionView)
        view.addSubview(buttonsStackView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: NewHabitConstants.Layout.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: NewHabitConstants.Layout.titleTextFieldTopInset),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NewHabitConstants.Layout.textFieldHorizontalInset),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NewHabitConstants.Layout.textFieldHorizontalInset),
            titleTextField.heightAnchor.constraint(equalToConstant: NewHabitConstants.Layout.titleTextFieldHeight),
            
            characterLimitLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: NewHabitConstants.Layout.characterLimitLabelTopInset),
            characterLimitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NewHabitConstants.Layout.textFieldHorizontalInset),
            characterLimitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NewHabitConstants.Layout.textFieldHorizontalInset),
            characterLimitLabel.heightAnchor.constraint(equalToConstant: NewHabitConstants.Layout.characterLimitLabelHeight),
            
            optionsTableView.topAnchor.constraint(equalTo: characterLimitLabel.bottomAnchor, constant: NewHabitConstants.Layout.optionsTableViewTopInset),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NewHabitConstants.Layout.optionsTableHorizontalInset),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NewHabitConstants.Layout.optionsTableHorizontalInset),
            optionsTableView.heightAnchor.constraint(equalToConstant: NewHabitConstants.Layout.optionsTableViewHeight),
            
            collectionView.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            collectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
            
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NewHabitConstants.Layout.buttonsStackViewHorizontalInset),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NewHabitConstants.Layout.buttonsStackViewHorizontalInset),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: NewHabitConstants.Layout.buttonsStackViewHeight)
        ])
    }
    
    // MARK: - Validation
    private func updateCreateButtonState() {
        let isValid = isFormValid
        createButton.isEnabled = isValid
        createButton.backgroundColor = isValid ? .ypBlack : .ypGray
    }
    
    private var isFormValid: Bool {
        let trimmedText = titleTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        return !trimmedText.isEmpty
            && selectedCategory != nil
            && !selectedDays.isEmpty
            && !selectedEmoji.isEmpty
            && selectedColor != .white
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count >= NewHabitConstants.Limits.titleMaxLength {
            if text.count > NewHabitConstants.Limits.titleMaxLength {
                textField.text = String(text.prefix(NewHabitConstants.Limits.titleMaxLength))
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
        guard isFormValid,
              let title = titleTextField.text?.trimmingCharacters(in: .whitespaces),
              let category = selectedCategory else { return }
        
        print("DEBUG: Creating tracker with title: \(title), category: \(category) (type: \(type(of: category))") // Проверьте тип category
        
        let newTracker = Tracker(
            id: UUID(),
            name: title,
            color: selectedColor,
            emoji: selectedEmoji,
            schedule: selectedDays,
            isHabit: true,
            isPinned: false,
            
        )
        
        print("DEBUG: Tracker created: \(newTracker.name)")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.configure(
                title: R.string.localizable.newHabitCategory(),
                subtitle: selectedCategory
            )
        } else {
            let subtitle: String?
            if selectedDays.count == 7 {
                subtitle = R.string.localizable.commonEveryday()
            } else {
                subtitle = selectedDays.isEmpty ? nil : selectedDays.map { $0.shortName }.joined(separator: ", ")
            }
            cell.configure(
                title: R.string.localizable.newHabitSchedule(),
                subtitle: subtitle
            )
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewHabitModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NewHabitConstants.Layout.titleTextFieldHeight
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
            let categoryModalVC = AddCategoryModalViewController()
            categoryModalVC.modalPresentationStyle = .pageSheet
            categoryModalVC.modalTransitionStyle = .coverVertical
            
            categoryModalVC.onCategorySelected = { [weak self] categoryName in
                self?.selectedCategory = categoryName
                self?.optionsTableView.reloadData()
                self?.updateCreateButtonState()
            }
            
            present(categoryModalVC, animated: true)
            
        } else if indexPath.row == 1 {
            let scheduleVC = SelectScheduleModalViewController()
            scheduleVC.delegate = self
            scheduleVC.modalPresentationStyle = .formSheet
            present(scheduleVC, animated: true)
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

// MARK: - EmojiColorSelectionDelegate
extension NewHabitModalViewController: EmojiColorSelectionDelegate {
    func didSelectEmoji(_ emoji: String) {
        selectedEmoji = emoji
        updateCreateButtonState()
    }
    
    func didSelectColor(_ color: UIColor) {
        selectedColor = color
        updateCreateButtonState()
    }
}
