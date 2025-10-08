import UIKit

final class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    private lazy var stubLabel = UILabel.stubLabel(withText: "Анализировать пока нечего")
    
    private let coreDataManager: CoreDataManager
    
    // Данные для таблицы
    private let statisticsData = [
        ("6", "Лущил период"),
        ("2", "Идеальные дни"),
        ("5", "Трекеров заверено"),
        ("4", "Среднее значение")
    ]
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupConstraints()
        updateViewBasedOnData()
    }
    
    private func setupNavigation() {
        title = "Статистика"
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
    
    private func updateViewBasedOnData() {
        if !statisticsData.isEmpty {
            stubStack.isHidden = true
            tableView.reloadData()
        } else {
            stubStack.isHidden = false
            tableView.isHidden = true
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return statisticsData.count // Каждая ячейка в отдельной секции для отступов
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Одна ячейка на секцию
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.reuseIdentifier, for: indexPath) as? StatisticsCell else {
            return UITableViewCell()
        }
        let data = statisticsData[indexPath.section]
        cell.configure(withNumber: data.0, title: data.1)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
}
