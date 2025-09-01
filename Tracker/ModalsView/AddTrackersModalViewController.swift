import UIKit

protocol AddTrackersModalDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, categoryTitle: String)
    func didCreateEvent(_ event: Tracker, categoryTitle: String)
}

final class AddTrackersModalViewController: UIViewController {
    // MARK: - Constants
    private enum AddTrackersConstants {
        struct Layout {
            static let cornerRadius: CGFloat = 10
            static let titleTopInset: CGFloat = 27
            static let stackSpacing: CGFloat = 16
            static let stackLeadingInset: CGFloat = 16
            static let stackTrailingInset: CGFloat = -16
            static let buttonHeight: CGFloat = 60
        }
        
        struct Strings {
            static let titleText = "Создание трекера"
            static let habitButtonTitle = "Привычка"
            static let eventButtonTitle = "Нерегулярное событие"
        }
    }
    
    // MARK: - Properties
    weak var delegate: AddTrackersModalDelegate?
    
    // MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle(AddTrackersConstants.Strings.titleText)
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = AddTrackersConstants.Layout.stackSpacing
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var addHabitButton = UIButton.ypAddModalButton(
        title: AddTrackersConstants.Strings.habitButtonTitle,
        target: self,
        action: #selector(addHabitButtonTapped)
    )
    
    private lazy var addEventButton = UIButton.ypAddModalButton(
        title: AddTrackersConstants.Strings.eventButtonTitle,
        target: self,
        action: #selector(addEventButtonTapped)
    )
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = AddTrackersConstants.Layout.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(addHabitButton)
        buttonsStackView.addArrangedSubview(addEventButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: AddTrackersConstants.Layout.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AddTrackersConstants.Layout.stackLeadingInset),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: AddTrackersConstants.Layout.stackTrailingInset),
            
            addHabitButton.heightAnchor.constraint(equalToConstant: AddTrackersConstants.Layout.buttonHeight),
            addEventButton.heightAnchor.constraint(equalToConstant: AddTrackersConstants.Layout.buttonHeight)
        ])
    }
    
    // MARK: - Actions
    @objc private func addHabitButtonTapped() {
        let newHabitVC = NewHabitModalViewController()
        newHabitVC.delegate = self
        newHabitVC.modalPresentationStyle = .pageSheet
        newHabitVC.modalTransitionStyle = .coverVertical
        present(newHabitVC, animated: true)
    }
    
    @objc private func addEventButtonTapped() {
        let newEventVC = NewEventModalViewController()
        newEventVC.delegate = self
        newEventVC.modalPresentationStyle = .pageSheet
        newEventVC.modalTransitionStyle = .coverVertical
        present(newEventVC, animated: true)
    }
}

// MARK: - NewHabitDelegate
extension AddTrackersModalViewController: NewHabitDelegate, EventDelegate {
    func didCreateTracker(_ tracker: Tracker, categoryTitle: String) {
        delegate?.didCreateTracker(tracker, categoryTitle: categoryTitle)
        
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: true) { [weak self] in
                self?.dismiss(animated: true)
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    func didCreateEvent(_ event: Tracker, categoryTitle: String) {
        delegate?.didCreateEvent(event, categoryTitle: categoryTitle)
        
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: true) { [weak self] in
                self?.dismiss(animated: true)
            }
        } else {
            dismiss(animated: true)
        }
    }
}
