import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var stubStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TrackersViewConstants.Layout.stubStackSpacing
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.reuseIdentifier)
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()
    
    private let stubImageView = UIImageView.stubImage()
    
    private lazy var stubLabel = UILabel.stubLabel(
        withText: R.string.localizable.statisticsEmptyState()
    )
    
    // MARK: - Dependencies
    private let coreDataManager: CoreDataManager
    private let statisticsService: StatisticsServiceProtocol
    private var statistics: Statistics = .zero
    private let analytics = AnalyticsService.shared
    
    // MARK: - Data
    private enum Metric: Int, CaseIterable {
        case bestStreak
        case perfectDays
        case completedTrackers
        case averagePerDay
        
        var title: String {
            switch self {
            case .bestStreak:
                R.string.localizable.statisticsBestStreak()
            case .perfectDays:
                R.string.localizable.statisticsPerfectDays()
            case .completedTrackers:
                R.string.localizable.statisticsCompletedTrackers()
            case .averagePerDay:
                R.string.localizable.statisticsAveragePerDay()
            }
        }
    }
    
    // MARK: - Init
    init(coreDataManager: CoreDataManager, statisticsService: StatisticsServiceProtocol = StatisticsService()) {
        self.coreDataManager = coreDataManager
        self.statisticsService = statisticsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupConstraints()
        updateViewBasedOnData()
        statistics = statisticsService.calculateStatistics()
        updateViewBasedOnData()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataDidChange),
            name: .coreDataDidChange,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           reportAnalytics(event: "open", screen: "Statistics")
       }
       
       override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
           reportAnalytics(event: "close", screen: "Statistics")
       }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Analytics
     private func reportAnalytics(event: String, screen: String, item: String? = nil) {
         var params: [AnyHashable: Any] = ["screen": screen]
         if let item = item {
             params["item"] = item
         }
         print("📊 Analytics -> event=\(event), screen=\(screen), item=\(item ?? "nil")")
         analytics.report(event: event, params: params)
     }
     
    
    // MARK: - Setup Methods
    private func setupNavigation() {
        title = R.string.localizable.statisticsTitle()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        stubImageView.image = .stubEmoji
        
        view.addSubview(stubStack)
        stubStack.addArrangedSubview(stubImageView)
        stubStack.addArrangedSubview(stubLabel)
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 246),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Helpers
    private func updateViewBasedOnData() {
        let isEmpty = statistics.bestStreak == 0 &&
        statistics.perfectDays == 0 &&
        statistics.completedTrackers == 0 &&
        statistics.averagePerDay == 0
        
        stubStack.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        
        if !isEmpty {
            tableView.reloadData()
        }
    }
    
    private func recomputeAndReload() {
        statistics = statisticsService.calculateStatistics()
        updateViewBasedOnData()
    }
    
    @objc private func dataDidChange() {
        recomputeAndReload()
    }
    
}

// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Metric.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let metric = Metric(rawValue: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.reuseIdentifier, for: indexPath) as? StatisticsCell else {
            return UITableViewCell()
        }
        let value: Int
        switch metric {
        case .bestStreak: value = statistics.bestStreak
        case .perfectDays: value = statistics.perfectDays
        case .completedTrackers: value = statistics.completedTrackers
        case .averagePerDay: value = statistics.averagePerDay
        }
        
        cell.configure(withNumber: value, title: metric.title)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
}

