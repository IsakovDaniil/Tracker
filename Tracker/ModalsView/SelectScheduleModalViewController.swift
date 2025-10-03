import UIKit

protocol SelectScheduleDelegate: AnyObject {
    func didSelectDays(_ days: [Weekday])
}

final class SelectScheduleModalViewController: UIViewController {
    
    // MARK: - Properties
    private var switchStates = [Bool](repeating: false, count: Weekday.allCases.count)
    weak var delegate: SelectScheduleDelegate?
    
    // MARK: - UI Elements
    private let titleLabel = UILabel.ypTitle(
        R.string.localizable.scheduleTitle()
    )
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(WeekdaysCell.self, forCellReuseIdentifier: WeekdaysCell.identifier)
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.ypBackground
        table.layer.cornerRadius = SelectScheduleConstants.Layout.tableCornerRadius
        table.layer.masksToBounds = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var doneButton = UIButton.ypAddModalButton(
        title: R.string.localizable.commonDone(),
        target: self,
        action: #selector(doneButtonTapped)
    )
    
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
        view.layer.cornerRadius = SelectScheduleConstants.Layout.viewCornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: SelectScheduleConstants.Layout.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SelectScheduleConstants.Layout.tableTopInset),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -SelectScheduleConstants.Layout.tableBottomInset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SelectScheduleConstants.Layout.tableHorizontalInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SelectScheduleConstants.Layout.tableHorizontalInset),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -SelectScheduleConstants.Layout.doneButtonBottomInset),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SelectScheduleConstants.Layout.doneButtonHorizontalInset),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SelectScheduleConstants.Layout.doneButtonHorizontalInset),
            doneButton.heightAnchor.constraint(equalToConstant: SelectScheduleConstants.Layout.doneButtonHeight)
        ])
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        let selectedDays = Weekday.allCases.enumerated()
            .filter { switchStates[$0.offset] }
            .map { $0.element }
        delegate?.didSelectDays(selectedDays)
        dismiss(animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate
extension SelectScheduleModalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekdaysCell.identifier, for: indexPath) as? WeekdaysCell else {
            return UITableViewCell()
        }
        let weekday = Weekday.allCases[indexPath.row]
        cell.configure(with: weekday.localizedName, isOn: switchStates[indexPath.row])
        cell.toggleSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        cell.toggleSwitch.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / CGFloat(Weekday.allCases.count)
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
        switchStates[sender.tag] = sender.isOn
    }
}
