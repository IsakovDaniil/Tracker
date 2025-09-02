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
    private var filteredCategories: [TrackerCategory] = []
    private var selectedDate: Date = Date()
    
    
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
        bar.delegate = self
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
        collection.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackerHeaderView")
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
        setupInitialData()
        updateFilteredCategories()
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
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    // MARK: - Navigation
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
    
    // MARK: - Data Setup
    private func setupInitialData() {
        categories = []
    }
    
    // MARK: - Filtering and Data Management
    private func updateFilteredCategories() {
        let selectedWeekday = getWeekdayFromDate(selectedDate)
        let searchText = searchBar.text?.lowercased() ?? ""
        
        filteredCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let isDayMatched = tracker.isHabit ? tracker.schedule.contains(selectedWeekday) : true
                let isSearchMatched = searchText.isEmpty || tracker.name.lowercased().contains(searchText)
                
                return isDayMatched && isSearchMatched
            }
            
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        collectionView.reloadData()
        updateStubVisibility()
    }
    
    private func updateStubVisibility() {
        let hasData = !filteredCategories.isEmpty
        stubStack.isHidden = hasData
        collectionView.isHidden = !hasData
    }
    
    private func getWeekdayFromDate(_ date: Date) -> Weekday {
        let calendar = Calendar.current
        let weekdayComponent = calendar.component(.weekday, from: date)
        
        switch weekdayComponent {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .monday
        }
    }
    
    // MARK: - Tracker Management
    func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) {
        var updatedCategories = categories
        if let index = updatedCategories.firstIndex(where: { $0.title == title }) {
            var updatedTrackers = updatedCategories[index].trackers
            updatedTrackers.append(tracker)
            updatedCategories[index] = TrackerCategory(title: title, trackers: updatedTrackers)
        } else {
            updatedCategories.append(TrackerCategory(title: title, trackers: [tracker]))
        }
        categories = updatedCategories
        updateFilteredCategories()
        
    }
    
    private func markTrackerCompleted(_ trackerID: UUID, on date: Date) {
        let newRecord = TrackerRecord(trackerID: trackerID, date: date)
        completedTrackers.append(newRecord)
        collectionView.reloadData()
    }
    
    private func unmarkTrackerCompleted(_ trackerID: UUID, on date: Date) {
        completedTrackers = completedTrackers.filter { record in
            !(record.trackerID == trackerID && Calendar.current.isDate(record.date, inSameDayAs: date))
        }
        collectionView.reloadData()
    }
    
    private func isTrackerCompleted(_ trackerID: UUID, on date: Date) -> Bool {
        return completedTrackers.contains { record in
            record.trackerID == trackerID && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
    
    private func getCompletionCount(for trackerID : UUID) -> Int {
        return completedTrackers.filter { $0.trackerID == trackerID }.count
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let modalVC = AddTrackersModalViewController()
        modalVC.delegate = self
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.modalTransitionStyle = .coverVertical
        present(modalVC, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        updateFilteredCategories()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}
// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let isCompleted = isTrackerCompleted(tracker.id, on: selectedDate)
        let completionCount = getCompletionCount(for: tracker.id)
        
        cell.configure(
            with: tracker,
            selectedDate: selectedDate,
            isCompleted: isCompleted,
            completionCount: completionCount
        ) { [weak self] trackerID, date, isCompleted in
            if isCompleted {
                self?.markTrackerCompleted(trackerID, on: date)
            } else {
                self?.unmarkTrackerCompleted(trackerID, on: date)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "TrackerHeaderView",
                for: indexPath
              ) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        
        header.configure(with: filteredCategories[indexPath.section].title)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = max(0, collectionView.frame.width - 16)
        let cellWidth = availableWidth / 2
        return CGSize(width: max(0, cellWidth), height: max(0, 148))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateFilteredCategories()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - AddTrackersModalDelegate
extension TrackersViewController: AddTrackersModalDelegate {
    func didCreateTracker(_ tracker: Tracker, categoryTitle: String) {
        addTracker(tracker, toCategoryWithTitle: categoryTitle)
    }
    
    func didCreateEvent(_ event: Tracker, categoryTitle: String) {
        addTracker(event, toCategoryWithTitle: categoryTitle)
    }
}

