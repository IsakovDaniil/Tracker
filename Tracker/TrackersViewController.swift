import UIKit

final class TrackersViewController: UIViewController, NewHabitDelegate, EventDelegate {
    
    // MARK: - Properties
    private let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore
    private var categories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []
    private var selectedDate: Date = Date()
    private var currentFilter: TrackerFilterType = .allTrackers
    
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
        label.text = R.string.localizable.trackersTitle()
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: TrackersViewConstants.Typography.titleLabelFontSize, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = R.string.localizable.trackersSearchBarPlaceholder()
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
    
    private let stubImageView = UIImageView.stubImage()
    
    private lazy var stubLabel = UILabel.stubLabel(withText: R.string.localizable.trackersStubText())
    
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
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localizable.trackersFilters(), for: .normal)
        button.backgroundColor = .ypBlue
        button.layer.cornerRadius = 16
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Service
    private let analytics = AnalyticsService.shared
    
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
        setupView()
        setupConstraints()
        setupNavigation()
        setupStoreDelegate()
        loadData()
        updateFilteredCategories()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = UIColor.ypWhite
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(stubStack)
        view.addSubview(filterButton)
        view.bringSubviewToFront(filterButton)
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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 131),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
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
        
        var allPinnedTrackers: [Tracker] = []
        var regularCategories: [TrackerCategory] = []
        
        for category in categories {
            let filteredTrackers = category.trackers.filter { tracker in
                let isDayMatched = tracker.isHabit ? tracker.schedule.contains(selectedWeekday) : true
                let isSearchMatched = searchText.isEmpty || tracker.name.lowercased().contains(searchText)
                let isFilterMatched = matchesCurrentFilter(tracker: tracker)
                
                return isDayMatched && isSearchMatched && isFilterMatched
            }
            
            let pinnedTrackers = filteredTrackers.filter { $0.isPinned }
            let unpinnedTrackers = filteredTrackers.filter { !$0.isPinned }
            
            allPinnedTrackers.append(contentsOf: pinnedTrackers)
            
            if !unpinnedTrackers.isEmpty {
                regularCategories.append(TrackerCategory(title: category.title, trackers: unpinnedTrackers))
            }
        }
        
        filteredCategories = []
        
        if !allPinnedTrackers.isEmpty {
            filteredCategories.append(TrackerCategory(
                title: R.string.localizable.trackersAllPinnedTrackers(),
                trackers: allPinnedTrackers)
            )
        }
        
        filteredCategories.append(contentsOf: regularCategories)
        
        collectionView.reloadData()
        updateStubVisibility()
        updateFilterButtonVisibility()
    }
    
    private func matchesCurrentFilter(tracker: Tracker) -> Bool {
        switch currentFilter {
        case .allTrackers, .todayTrackers:
            return true
        case .completed:
            return isTrackerCompleted(tracker.id, on: selectedDate)
        case .notCompleted:
            return !isTrackerCompleted(tracker.id, on: selectedDate)
        }
    }
    
    private func updateStubVisibility() {
        let hasData = !filteredCategories.isEmpty
        
        if !hasData {
            if currentFilter == .completed || currentFilter == .notCompleted {
                stubLabel.text = R.string.localizable.trackersNoFound()
            } else {
                stubLabel.text = R.string.localizable.trackersStubText()
            }
        }
        
        stubStack.isHidden = hasData
        collectionView.isHidden = !hasData
    }
    
    private func updateFilterButtonVisibility() {
        let hasTrackersForSelectedDay = hasTrackersAvailableForDate(selectedDate)
        filterButton.isHidden = !hasTrackersForSelectedDay
        updateFilterButtonAppearance()
    }
    
    private func updateFilterButtonAppearance() {
        let isActive = currentFilter == .todayTrackers || currentFilter == .completed || currentFilter == .notCompleted
        filterButton.setTitleColor(isActive ? .ypRed : .white, for: .normal)
    }
    
    private func hasTrackersAvailableForDate(_ date: Date) -> Bool {
            let selectedWeekday = getWeekdayFromDate(date)
            
            for category in categories {
                for tracker in category.trackers {
                    let isDayMatched = tracker.isHabit ? tracker.schedule.contains(selectedWeekday) : true
                    if isDayMatched {
                        return true
                    }
                }
            }
            return false
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
    
    private func editTracker(at indexPath: IndexPath) {
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let categoryTitle = filteredCategories[indexPath.section].title
        let completedDays = getCompletionCount(for: tracker.id)
        
        if tracker.isHabit {
            let modalVC = NewHabitModalViewController(mode: .edit(tracker: tracker, categoryTitle: categoryTitle, completedDays: completedDays))
            modalVC.delegate = self
            modalVC.modalPresentationStyle = .pageSheet
            modalVC.modalTransitionStyle = .coverVertical
            present(modalVC, animated: true)
        } else {
            let modalVC = NewEventModalViewController(mode: .edit(tracker: tracker, categoryTitle: categoryTitle))
            modalVC.delegate = self
            modalVC.modalPresentationStyle = .pageSheet
            modalVC.modalTransitionStyle = .coverVertical
            present(modalVC, animated: true)
        }
    }
    
    private func togglePinTracker(at indexPath: IndexPath) {
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        
        do {
            try trackerStore.togglePinTracker(with: tracker.id)
            loadData()
            updateFilteredCategories()
        } catch {
            print("Error toggling pin tracker: \(error)")
        }
    }
    
    private func deleteTracker(at indexPath: IndexPath) {
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        
        let alert = UIAlertController(
            title: nil,
            message: R.string.localizable.trackersDeleteTracker(),
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(title: R.string.localizable.trackersDeleteAction(), style: .destructive) { [weak self] _ in
            self?.performDeleteTracker(tracker.id)
        }
        
        let cancelAction = UIAlertAction(title: R.string.localizable.trackersCancelAction(), style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func performDeleteTracker(_ trackerID: UUID) {
        do {
            try trackerStore.deleteTracker(withId: trackerID)
            loadData()
            updateFilteredCategories()
        } catch {
            print("Error deleting tracker: \(error)")
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
        dateFormatter.dateFormat = R.string.localizable.trackersDateFormat()
        let formattedDate = dateFormatter.string(from: selectedDate)
        print(R.string.localizable.trackersSelectedDate(formattedDate))
    }
    
    @objc private func filterButtonTapped() {
        let modalVC = FilterModalViewController(currentFilter: currentFilter)
        modalVC.delegate = self
        modalVC.modalPresentationStyle = .pageSheet
        modalVC.modalTransitionStyle = .coverVertical
        present(modalVC, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ -> UIMenu? in
            guard let self = self else { return nil }
            
            let tracker = self.filteredCategories[indexPath.section].trackers[indexPath.item]
            
            let pinTitle = tracker.isPinned ? R.string.localizable.trackersPinAction() : R.string.localizable.trackersUnpinAction()
            let pinAction = UIAction(
                title: pinTitle,
                image: nil
            ) { _ in
                self.togglePinTracker(at: indexPath)
            }
            
            let editAction = UIAction(
                title: R.string.localizable.trackersEditPinAction(),
                image: nil
            ) { _ in
                self.editTracker(at: indexPath)
            }
            
            let deleteAction = UIAction(
                title: R.string.localizable.trackersDeletePinAction(),
                image: nil,
                attributes: .destructive
            ) { _ in
                self.deleteTracker(at: indexPath)
            }
            
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
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
    
    func didEditTracker(_ tracker: Tracker, categoryTitle: String) {
        do {
            try trackerStore.updateTracker(tracker, toCategoryWithTitle: categoryTitle)
            loadData()
            updateFilteredCategories()
        } catch {
            print("Error updating tracker: \(error)")
        }
    }
}

// MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerStoreDelegate {
    func didUpdateTrackers() {
        loadData()
        updateFilteredCategories()
    }
}

// MARK: - TrackerFilterDelegate
extension TrackersViewController: FilterModalDelegate {
    func didSelectFilter(_ filterType: TrackerFilterType) {
        currentFilter = filterType
        
        if filterType == .todayTrackers {
            selectedDate = Date()
            datePicker.date = Date()
        }
        
        updateFilteredCategories()
    }
}


