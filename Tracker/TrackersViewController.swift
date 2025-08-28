import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Constants
    private enum ViewConstants {
        struct Layout {
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
        
        struct Strings {
            static let titleText = "Трекеры"
            static let searchBarPlaceholder = "Поиск"
            static let stubLabelText = "Что будем отслеживать?"
        }
    }
    
    // MARK: - Properties
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - UI Elements
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.backgroundColor = UIColor.ypWhite
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhite
        setupView()
        setupConstraints()
        setupNavigation()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(stubStack)
        stubStack.addArrangedSubview(stubImageView)
        stubStack.addArrangedSubview(stubLabel)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.Layout.titleLabelLeadingInset),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewConstants.Layout.searchBarTopInset),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.Layout.searchBarLeadingInset),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ViewConstants.Layout.searchBarTrailingInset),
            searchBar.heightAnchor.constraint(equalToConstant: ViewConstants.Layout.searchBarHeight),
            
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: ViewConstants.Layout.stubStackTopInset),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
        ])
    }
    
    private func setupNavigation() {
        let addButton = UIBarButtonItem(image: UIImage.addTracker,
                                        style: .plain,
                                        target: self,
                                        action: #selector(addButtonTapped))
        addButton.tintColor = UIColor.ypBlack
        
        let dateButton = UIBarButtonItem(customView: datePicker)
        dateButton.tintColor = UIColor.ypBlack
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = dateButton
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
        let modalVC = AddTrackersModalViewController()
            modalVC.modalPresentationStyle = .pageSheet
            modalVC.modalTransitionStyle = .coverVertical
            present(modalVC, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCell ?? TrackerCell()
        return cell
    }
    
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
}

extension TrackersViewController: UICollectionViewDelegate {
    
}
