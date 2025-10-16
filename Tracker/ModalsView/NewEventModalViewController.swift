import UIKit

protocol EventDelegate: AnyObject {
    func didCreateEvent(_ event: Tracker, categoryTitle: String)
    func didEditTracker(_ tracker: Tracker, categoryTitle: String)
}

final class NewEventModalViewController: UIViewController {
    
    // MARK: - Mode
    enum Mode {
        case create
        case edit(tracker: Tracker, categoryTitle: String)
    }
    
    // MARK: - Properties
    weak var delegate: EventDelegate?
    private let mode: Mode
    private var selectedCategory: String? = nil
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
            title = R.string.localizable.newEventTitle()
        case .edit:
            title = R.string.localizable.newEventTitleEdit()
        }
        return UILabel.ypTitle(title)
    }()
    
    private lazy var titleTextField: UITextField = .makeTitleTextField(
        delegate: self,
        action: #selector(textFieldDidChange)
    )
    
    private let characterLimitLabel = UILabel.makeCharacterLimitLabel()
    
    private lazy var optionsTableView = UITableView.makeOptionsTableView(
        dataSource: self,
        delegate: self,
        separatorStyle: .none
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
        stack.spacing = 8
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
            title = R.string.localizable.newEventSave()
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
    
    // MARK: - Setup View
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = NewEventConstants.Layout.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
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
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: NewEventConstants.Layout.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: NewEventConstants.Layout.textFieldTopInset),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NewEventConstants.Layout.sideInset),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NewEventConstants.Layout.sideInset),
            titleTextField.heightAnchor.constraint(equalToConstant: NewEventConstants.Layout.textFieldHeight),
            
            characterLimitLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: NewEventConstants.Layout.characterLimitTopInset),
            characterLimitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NewEventConstants.Layout.sideInset),
            characterLimitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NewEventConstants.Layout.sideInset),
            characterLimitLabel.heightAnchor.constraint(equalToConstant: NewEventConstants.Layout.characterLimitHeight),
            
            optionsTableView.topAnchor.constraint(equalTo: characterLimitLabel.bottomAnchor, constant: NewEventConstants.Layout.tableTopInset),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NewEventConstants.Layout.sideInset),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NewEventConstants.Layout.sideInset),
            optionsTableView.heightAnchor.constraint(equalToConstant: NewEventConstants.Layout.tableHeight),
            
            collectionView.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            collectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NewEventConstants.Layout.buttonsSideInset),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NewEventConstants.Layout.buttonsSideInset),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: NewEventConstants.Layout.buttonsHeight),
        ])
    }
    
    private func setupInitialData() {
        if case let .edit(tracker, categoryTitle) = mode {
            titleTextField.text = tracker.name
            selectedCategory = categoryTitle
            selectedColor = tracker.color
            selectedEmoji = tracker.emoji
            emojiColorManager.setSelectedEmoji(tracker.emoji)
            emojiColorManager.setSelectedColor(tracker.color)
            optionsTableView.reloadData()
            collectionView.reloadData()
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
        && !selectedEmoji.isEmpty
        && selectedColor != .white
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count >= NewEventConstants.Limits.titleCharacterLimit {
            if text.count > NewEventConstants.Limits.titleCharacterLimit {
                textField.text = String(text.prefix(NewEventConstants.Limits.titleCharacterLimit))
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
                schedule: Weekday.allCases,
                isHabit: false,
                isPinned: false
            )
            delegate?.didCreateEvent(tracker, categoryTitle: category)
        case .edit(let original, _):
            tracker = Tracker(
                id: original.id,
                name: title,
                color: selectedColor,
                emoji: selectedEmoji,
                schedule: Weekday.allCases,
                isHabit: false,
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

// MARK: - UITextFieldDelegate
extension NewEventModalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDataSource
extension NewEventModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionCell else {
            return UITableViewCell()
        }
        
        cell.configure(
            title: R.string.localizable.newEventCategory(),
            subtitle: selectedCategory
        )
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewEventModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewEventConstants.Layout.tableHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row == .zero else { return }
        
        let categoryModalVC = AddCategoryModalViewController()
        categoryModalVC.modalPresentationStyle = .pageSheet
        categoryModalVC.modalTransitionStyle = .coverVertical
        
        categoryModalVC.onCategorySelected = { [weak self] categoryName in
            self?.selectedCategory = categoryName
            self?.optionsTableView.reloadData()
            self?.updateCreateButtonState()
        }
        
        present(categoryModalVC, animated: true)
    }
}

// MARK: - EmojiColorSelectionDelegate
extension NewEventModalViewController: EmojiColorSelectionDelegate {
    func didSelectEmoji(_ emoji: String) {
        selectedEmoji = emoji
        updateCreateButtonState()
    }
    
    func didSelectColor(_ color: UIColor) {
        selectedColor = color
        updateCreateButtonState()
    }
}
