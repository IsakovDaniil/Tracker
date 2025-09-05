import UIKit

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var tracker: Tracker?
    private var selectedDate: Date?
    private var isCompletedToday: Bool = false
    private var completionCount: Int = .zero
    private var completionHandler: ((UUID, Date, Bool) -> Void)?
    
    // MARK: - UI Elements
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = TrackerCellConstants.Layout.cardCornerRadius
        view.layer.borderWidth = TrackerCellConstants.Layout.cardBorderWidth
        view.layer.borderColor = UIColor.ypBorderCard.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = TrackerCellConstants.Layout.emojiViewCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(TrackerCellConstants.Layout.emojiViewBackgroundAlpha)
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: TrackerCellConstants.Typography.emojiLabelFontSize,
            weight: TrackerCellConstants.Typography.emojiLabelWeight
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: TrackerCellConstants.Typography.titleLabelFontSize,
            weight: TrackerCellConstants.Typography.titleLabelWeight
        )
        label.textColor = .ypWhite
        label.numberOfLines = TrackerCellConstants.Layout.titleLabelNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: TrackerCellConstants.Typography.counterLabelFontSize,
            weight: TrackerCellConstants.Typography.counterLabelWeight
        )
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = TrackerCellConstants.Layout.counterButtonCornerRadius
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(counterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupView() {
        contentView.addSubview(cardView)
        cardView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        contentView.addSubview(counterView)
        counterView.addSubview(counterLabel)
        counterView.addSubview(counterButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: TrackerCellConstants.Layout.cardHeight),
            
            emojiView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: TrackerCellConstants.Layout.emojiViewTopInset),
            emojiView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: TrackerCellConstants.Layout.emojiViewLeadingInset),
            emojiView.widthAnchor.constraint(equalToConstant: TrackerCellConstants.Layout.emojiViewSize),
            emojiView.heightAnchor.constraint(equalToConstant: TrackerCellConstants.Layout.emojiViewSize),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: TrackerCellConstants.Layout.titleLabelLeadingInset),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: TrackerCellConstants.Layout.titleLabelTrailingInset),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: TrackerCellConstants.Layout.titleLabelBottomInset),
            
            counterView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            counterView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            counterView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            counterView.heightAnchor.constraint(equalToConstant: TrackerCellConstants.Layout.counterViewHeight),
            
            counterLabel.topAnchor.constraint(equalTo: counterView.topAnchor, constant: TrackerCellConstants.Layout.counterLabelTopInset),
            counterLabel.leadingAnchor.constraint(equalTo: counterView.leadingAnchor, constant: TrackerCellConstants.Layout.counterLabelLeadingInset),
            
            counterButton.trailingAnchor.constraint(equalTo: counterView.trailingAnchor, constant: TrackerCellConstants.Layout.counterButtonTrailingInset),
            counterButton.topAnchor.constraint(equalTo: counterView.topAnchor, constant: TrackerCellConstants.Layout.counterButtonTopInset),
            counterButton.widthAnchor.constraint(equalToConstant: TrackerCellConstants.Layout.counterButtonSize),
            counterButton.heightAnchor.constraint(equalToConstant: TrackerCellConstants.Layout.counterButtonSize)
        ])
    }
    
    // MARK: - Configuration
    func configure(
        with tracker: Tracker,
        selectedDate: Date,
        isCompleted: Bool,
        completionCount: Int,
        completionHandler: @escaping (UUID, Date, Bool) -> Void
    ) {
        self.tracker = tracker
        self.selectedDate = selectedDate
        self.isCompletedToday = isCompleted
        self.completionCount = completionCount
        self.completionHandler = completionHandler
        
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        cardView.backgroundColor = tracker.color
        
        updateCounterLabel()
        updateCounterButton()
    }
    
    private func updateCounterLabel() {
        let daysText: String
        let count = completionCount
        
        switch count {
        case 0:
            daysText = TrackerCellConstants.Strings.daysMany
        case 1:
            daysText = TrackerCellConstants.Strings.daySingle
        case 2...4:
            daysText = TrackerCellConstants.Strings.daysFew
        default:
            daysText = TrackerCellConstants.Strings.daysMany
        }
        
        counterLabel.text = "\(count) \(daysText)"
    }
    
    private func updateCounterButton() {
        guard let tracker else { return }
        
        let buttonColor = isCompletedToday ?
        tracker.color.withAlphaComponent(0.3) :
        tracker.color
        
        counterButton.backgroundColor = buttonColor
        
        let buttonImage = isCompletedToday ? UIImage.done : UIImage.plus
        
        counterButton.setImage(buttonImage, for: .normal)
        counterButton.tintColor = UIColor.ypWhite
        
        updateButtonAvailability()
    }
    
    private func updateButtonAvailability() {
        guard let selectedDate else { return }
        
        let today = Date()
        let calendar = Calendar.current
        
        let selectedDateOnly = calendar.startOfDay(for: selectedDate)
        let todayOnly = calendar.startOfDay(for: today)
        
        if selectedDateOnly > todayOnly {
            counterButton.isEnabled = false
            counterButton.alpha = TrackerCellConstants.Layout.buttonDisabledAlpha
        } else {
            counterButton.isEnabled = true
            counterButton.alpha = TrackerCellConstants.Layout.buttonEnabledAlpha
        }
    }
    
    // MARK: - Action
    @objc private func counterButtonTapped() {
        guard let tracker,
              let selectedDate,
              let completionHandler else { return }
        
        let newCompletionState = !isCompletedToday
        
        completionHandler(tracker.id, selectedDate, newCompletionState)
        
        isCompletedToday = newCompletionState
        
        if newCompletionState {
            completionCount += 1
        } else {
            completionCount = max(0, completionCount - 1)
        }
        
        updateCounterLabel()
        updateCounterButton()
    }
}
