import UIKit

final class TrackerCell: UICollectionViewCell {
    // MARK: - Properties
    private var tracker: Tracker?
    private var selectedDate: Date?
    private var isCompletedToday: Bool = false
    private var completionCount: Int = 0
    private var completionHandler: ((UUID, Date, Bool) -> Void)?
    
    // MARK: - UI Elements
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.ypBorderCard.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.ypWhite
        label.numberOfLines = 2
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(counterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Init
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
        cardView.addSubview(emojiLabel)
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
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            counterView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            counterView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            counterView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            counterView.heightAnchor.constraint(equalToConstant: 58),
            
            counterLabel.topAnchor.constraint(equalTo: counterView.topAnchor, constant: 16),
            counterLabel.leadingAnchor.constraint(equalTo: counterView.leadingAnchor, constant: 12),
            
            
            counterButton.trailingAnchor.constraint(equalTo: counterView.trailingAnchor, constant: -12),
            counterButton.centerYAnchor.constraint(equalTo: counterView.centerYAnchor),
            counterButton.widthAnchor.constraint(equalToConstant: 34),
            counterButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    // MARK: - Configuration
    private func configuration(
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
    }
    
    //MARK: - Action
    @objc private func counterButtonTapped() {
        
    }
}

