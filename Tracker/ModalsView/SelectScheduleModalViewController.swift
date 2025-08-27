import UIKit

protocol SelectScheduleDelegate: AnyObject {
    func didSelectDays(_ days: [String])
}

final class SelectScheduleModalViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle("Расписание")
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(WeekdaysCell.self, forCellReuseIdentifier: WeekdaysCell.identifier)
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.ypBackground
        table.layer.cornerRadius = 16
        table.layer.masksToBounds = true
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private lazy var doneButton = UIButton.ypAddModalButton(
        title: "Готово",
        target: self,
        action: #selector(doneButtonTapped)
    )
    
    // MARK: - Data
    private let days = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private let shortDays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    private var switchStates = [Bool](repeating: false, count: 7)
    
    weak var delegate: SelectScheduleDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        tableView.reloadData()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - Action
    @objc private func doneButtonTapped() {
           let selectedDays = days.enumerated().filter { switchStates[$0.offset] }.map { shortDays[$0.offset] }
           delegate?.didSelectDays(selectedDays)
           dismiss(animated: true)
       }
}

// MARK: - UITableView DataSource & Delegate
extension SelectScheduleModalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekdaysCell.identifier, for: indexPath) as? WeekdaysCell else {
            return UITableViewCell()
        }
        cell.configure(with: days[indexPath.row], isOn: switchStates[indexPath.row])
        cell.toggleSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        cell.toggleSwitch.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(days.count)
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
        switchStates[sender.tag] = sender.isOn
        print("Day \(days[sender.tag]) switched to \(sender.isOn)")
    }
}
