import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Constants
    private enum ViewConstants {
        struct Layout {
            static let topStackTopInset: CGFloat = 1
            static let topStackLeadingInset: CGFloat = 6
            static let topStackTrailingInset: CGFloat = -16
            
            static let titleLabelTopInset: CGFloat = 1
            static let titleLabelLeadingInset: CGFloat = 16
            
            static let searchBarTopInset: CGFloat = 7
            static let searchBarLeadingInset: CGFloat = 10
            static let searchBarTrailingInset: CGFloat = -10
            static let searchBarHeight: CGFloat = 36
            
            static let stubStackTopInset: CGFloat = 230
            static let stubStackSpacing: CGFloat = 8
        }
        
        struct Typography {
            static let titleLabelFontSize: CGFloat = 34
            static let stubLabelFontSize: CGFloat = 12
        }
        
        struct Button {
            static let dataButtonCornerRadius: CGFloat = 8
            static let dataButtonTopInset: CGFloat = 6
            static let dataButtonLeadingInset: CGFloat = 5.5
            static let dataButtonBottomInset: CGFloat = 6
            static let dataButtonTrailingInset: CGFloat = 5.5
        }
        
        struct Strings {
            static let titleText = "Трекеры"
            static let searchBarPlaceholder = "Поиск"
            static let stubLabelText = "Что будем отслеживать?"
            static let dataButtonTitle = "14.12.22"
        }
    }
    
    // MARK: - Properties
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - UI Elements
    private lazy var topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.addTracker.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.ypBlack
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dataButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = ViewConstants.Strings.dataButtonTitle
        config.baseForegroundColor = UIColor.ypTextBlack
        config.contentInsets = NSDirectionalEdgeInsets(
            top: ViewConstants.Button.dataButtonTopInset,
            leading: ViewConstants.Button.dataButtonLeadingInset,
            bottom: ViewConstants.Button.dataButtonBottomInset,
            trailing: ViewConstants.Button.dataButtonTrailingInset
        )
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.backgroundColor = UIColor.ypBackgroundLight
        button.layer.cornerRadius = ViewConstants.Button.dataButtonCornerRadius
        button.addTarget(self, action: #selector(dataButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ViewConstants.Strings.titleText
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: ViewConstants.Typography.titleLabelFontSize, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = ViewConstants.Strings.searchBarPlaceholder
        bar.searchBarStyle = .minimal
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private lazy var stubStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = ViewConstants.Layout.stubStackSpacing
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.dizzyStar
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = ViewConstants.Strings.stubLabelText
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: ViewConstants.Typography.stubLabelFontSize, weight: .medium)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhite
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.addSubview(topStack)
        topStack.addArrangedSubview(addButton)
        topStack.addArrangedSubview(dataButton)
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(stubStack)
        stubStack.addArrangedSubview(stubImageView)
        stubStack.addArrangedSubview(stubLabel)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewConstants.Layout.topStackTopInset),
            topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.Layout.topStackLeadingInset),
            topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ViewConstants.Layout.topStackTrailingInset),
            
            titleLabel.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: ViewConstants.Layout.titleLabelTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.Layout.titleLabelLeadingInset),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewConstants.Layout.searchBarTopInset),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.Layout.searchBarLeadingInset),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ViewConstants.Layout.searchBarTrailingInset),
            searchBar.heightAnchor.constraint(equalToConstant: ViewConstants.Layout.searchBarHeight),
            
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: ViewConstants.Layout.stubStackTopInset)
        ])
    }
    
    // MARK: - Tracker Management
    private func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) {
        var updatedCategories = categories
        if let index = updatedCategories.firstIndex(where: { $0.title == title }) {
            var updatedTrackers = updatedCategories[index].trackers
            updatedTrackers.append(tracker)
            updatedCategories[index] = TrackerCategory(title: title, trackers: updatedTrackers)
        } else {
            updatedCategories.append(TrackerCategory(title: title, trackers: [tracker]))
        }
        categories = updatedCategories
    }
    
    private func markTrackerComplited(_ trackerID: UUID, on date: Date) {
        let newRecord = TrackerRecord(trackerID: trackerID, date: date)
        completedTrackers.append(newRecord)
    }
    
    private func unmarkTrackerComplited(_ trackerID: UUID, on date: Date) {
        completedTrackers = completedTrackers.filter { record in
            !(record.trackerID == trackerID && Calendar.current.isDate(record.date, inSameDayAs: date))
        }
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        print("Нажал на +")
    }
    
    @objc private func dataButtonTapped() {
        print("Нажал на Data")
    }
}
