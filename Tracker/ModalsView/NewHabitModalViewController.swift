import UIKit

protocol NewHabitDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, categoryTitle: String)
    func didCreateEvent(_ event: Tracker, categoryTitle: String)
    func didEditTracker(_ tracker: Tracker, categoryTitle: String)
}

final class NewHabitModalViewController: UIViewController {
    
    // MARK: - Mode
    enum Mode {
        case create
        case edit(tracker: Tracker, categoryTitle: String, completedDays: Int)
    }
    
    // MARK: - Properties
    weak var delegate: NewHabitDelegate?
    private let mode: Mode
    private var completedDaysCount: Int = 0
    
    private var selectedDays: [Weekday] = []
    private var selectedCategory: String?
    private var selectedColor: UIColor = .white
    private var selectedEmoji: String = ""
    
    private lazy var emojiColorManager: EmojiColorCollectionManager = {
        let manager = EmojiColorCollectionManager()
        manager.delegate = self
        return manager
    }()
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let title: String
        switch mode {
        case .create:
            title = R.string.localizable.newHabitTitle()
        case .edit:
            title = R.string.localizable.newHabitTitleEdit()
        }
        return UILabel.ypTitle(title)
    }()
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    private lazy var createButton: UIButton = {
        let title: String
        switch mode {
        case .create:
            title = R.string.localizable.commonCreate()
        case .edit:
            title = R.string.localizable.newHabitSave()
        }
        return UIButton.ypModalSecondaryButton(
            title: title,
            titleColor: .ypWhite,
            backgroundColor: .ypGray,
            target: self,
            action: #selector(createButtonTapped)
        )
    }()
    
    // MARK: - Init
    init(mode: Mode = .create) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupInitialData()
        updateCreateButtonState()
    }
    
    // MARK: - Setup Initial Data
    private func setupInitialData() {
        if case let .edit(tracker, categoryTitle, completedDays) = mode {
            titleTextField.text = tracker.name
            selectedCategory = categoryTitle
            selectedDays = tracker.schedule
            selectedColor = tracker.color
            selectedEmoji = tracker.emoji
            completedDaysCount = completedDays
            let format = NSLocalizedString("days_count", comment: "Number of days")
            daysLabel.text = String(format: format, completedDaysCount)
            emojiColorManager.setSelectedEmoji(tracker.emoji)
            emojiColorManager.setSelectedColor(tracker.color)
            optionsTableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = NewHabitConstants.Layout.viewCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .ypWhite
        
        view.addSubview(titleLabel)
        if case .edit = mode {
            view.addSubview(daysLabel)
        }
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
        
        switch mode {
        case .create:
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: NewHabitConstants.Layout.titleTopInset).isActive = true
        case .edit:
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: NewHabitConstants.Layout.titleTopInset),
                daysLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36),
                daysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NewHabitConstants.Layout.textFieldHorizontalInset),
                daysLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NewHabitConstants.Layout.textFieldHorizontalInset),
                
            ])
        }
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
        
        let tracker: Tracker
        switch mode {
        case .create:
            tracker = Tracker(
                id: UUID(),
                name: title,
                color: selectedColor,
                emoji: selectedEmoji,
                schedule: selectedDays,
                isHabit: true,
                isPinned: false
            )
            delegate?.didCreateTracker(tracker, categoryTitle: category)
        case .edit(let original, _, _):
            tracker = Tracker(
                id: original.id,
                name: title,
                color: selectedColor,
                emoji: selectedEmoji,
                schedule: selectedDays,
                isHabit: true,
                isPinned: original.isPinned
            )
            delegate?.didEditTracker(tracker, categoryTitle: category)
        }
        
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Mode Extension
extension NewHabitModalViewController.Mode {
    var tracker: Tracker? {
        if case let .edit(tracker, _, _) = self {
            return tracker
        }
        return nil
    }
    
    var categoryTitle: String? {
        if case let .edit(_, categoryTitle, _) = self {
            return categoryTitle
        }
        return nil
    }
    
    var completedDays: Int? {
        if case let .edit(_, _, completedDays) = self {
            return completedDays
        }
        return nil
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
