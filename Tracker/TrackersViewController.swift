import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    private let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    private var categories: [TrackerCategory] = []
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TrackersViewConstants.Strings.titleText
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: TrackersViewConstants.Typography.titleLabelFontSize, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = TrackersViewConstants.Strings.searchBarPlaceholder
        bar.searchBarStyle = .minimal
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private lazy var stubStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TrackersViewConstants.Layout.stubStackSpacing
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var stubImageView = UIImageView.stubImage()
    
    private lazy var stubLabel = UILabel.stubLabel(withText: TrackersViewConstants.Strings.stubLabelText)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: TrackersViewConstants.Strings.trackerCellIdentifier)
        collection.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersViewConstants.Strings.trackerHeaderViewIdentifier)
        collection.backgroundColor = UIColor.ypWhite
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Init
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.trackerStore = TrackerStore(context: coreDataManager.context)
        self.trackerCategoryStore = TrackerCategoryStore(context: coreDataManager.context)
        self.trackerRecordStore = TrackerRecordStore(context: coreDataManager.context)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhite
        setupView()
        setupConstraints()
        setupNavigation()
        setupStoreDelegate()
        loadData()
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
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TrackersViewConstants.Layout.titleLabelLeadingInset),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: TrackersViewConstants.Layout.searchBarTopInset),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TrackersViewConstants.Layout.searchBarLeadingInset),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: TrackersViewConstants.Layout.searchBarTrailingInset),
            searchBar.heightAnchor.constraint(equalToConstant: TrackersViewConstants.Layout.searchBarHeight),
            
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: TrackersViewConstants.Layout.stubStackTopInset),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: TrackersViewConstants.Layout.collectionViewTopInset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TrackersViewConstants.Layout.collectionViewHorizontalInset),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -TrackersViewConstants.Layout.collectionViewHorizontalInset),
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
    private func setupStoreDelegate() {
        trackerStore.delegate = self
    }
    
    private func loadData() {
        do {
            categories = try trackerCategoryStore.fetchAllCategories()
        } catch {
            print("Error loading categories: \(error)")
        }
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
    private func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) {
        do {
            try trackerStore.addTracker(tracker, to: title)
            loadData()
            updateFilteredCategories()
        } catch {
            print("Error adding tracker: \(error)")
        }
    }
    
    private func markTrackerCompleted(_ trackerID: UUID, on date: Date) {
        do {
            let record = TrackerRecord(trackerID: trackerID, date: date)
            try trackerRecordStore.addRecord(record)
            collectionView.reloadData()
        } catch {
            print("Error marking tracker as completed: \(error)")
        }
    }
    
    private func unmarkTrackerCompleted(_ trackerID: UUID, on date: Date) {
        do {
            try trackerRecordStore.removeRecord(for: trackerID, date: date)
            collectionView.reloadData()
        } catch {
            print("Error unmarking tracker: \(error)")
        }
    }
    
    private func isTrackerCompleted(_ trackerID: UUID, on date: Date) -> Bool {
        do {
            return try trackerRecordStore.isTrackerCompleted(trackerId: trackerID, date: date)
        } catch {
            print("Error checking tracker completion: \(error)")
            return false
        }
    }
    
    private func getCompletionCount(for trackerID: UUID) -> Int {
        do {
            return try trackerRecordStore.getCompletionCount(for: trackerID)
        } catch {
            print("Error getting completion count: \(error)")
            return 0
        }
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
        dateFormatter.dateFormat = TrackersViewConstants.Strings.dateFormat
        let formattedDate = dateFormatter.string(from: selectedDate)
        print(String(format: TrackersViewConstants.Strings.selectedDateMessage, formattedDate))
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersViewConstants.Strings.trackerCellIdentifier, for: indexPath) as? TrackerCell else {
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
                withReuseIdentifier: TrackersViewConstants.Strings.trackerHeaderViewIdentifier,
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
        let availableWidth = max(TrackersViewConstants.Layout.zeroInset, collectionView.frame.width - TrackersViewConstants.Layout.collectionViewAvailableWidthOffset)
        let cellWidth = availableWidth / 2
        return CGSize(width: max(TrackersViewConstants.Layout.zeroInset, cellWidth), height: max(TrackersViewConstants.Layout.zeroInset, TrackersViewConstants.Layout.collectionViewCellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        TrackersViewConstants.Layout.collectionViewMinimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: TrackersViewConstants.Layout.collectionViewHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: TrackersViewConstants.Layout.zeroInset, left: TrackersViewConstants.Layout.zeroInset, bottom: TrackersViewConstants.Layout.collectionViewSectionBottomInset, right: TrackersViewConstants.Layout.zeroInset)
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

// MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerStoreDelegate {
    func didUpdateTrackers() {
        loadData()
        updateFilteredCategories()
    }
}
