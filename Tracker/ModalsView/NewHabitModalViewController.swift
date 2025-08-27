import UIKit

final class NewHabitModalViewController: UIViewController {
    
    let handler = ModalHandler()
    
    // MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle("Новая привычка")
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(NameInputCell.self, forCellReuseIdentifier: "NameInputCell")
        table.register(CategoryScheduleCell.self, forCellReuseIdentifier: "CategoryScheduleCell")
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var cancelButton = UIButton.ypModalSecondaryButton(
        title: "Отменить",
        titleColor: .ypRed,
        backgroundColor: .clear,
        hasBorder: true
    ) { [weak self] in
        self?.handler.cancel()
    }
    
    private lazy var createButton = UIButton.ypModalSecondaryButton(
        title: "Создать",
        titleColor: .ypWhite,
        backgroundColor: .ypBlack
    ) { [weak self] in
        self?.handler.create()
    }
    
    private var selectedDays: [String] = []
    private var selectedCategory: String? = nil
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(buttonsStackView)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Helper Methods
    private func updateScheduleCell() {
        let scheduleText = selectedDays.isEmpty ? nil : selectedDays.joined(separator: ", ")
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? CategoryScheduleCell {
            cell.configure(category: selectedCategory, schedule: scheduleText)
        }
    }
}

// MARK: - UITableViewDataSource
extension NewHabitModalViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameInputCell", for: indexPath) as! NameInputCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryScheduleCell", for: indexPath) as! CategoryScheduleCell
            cell.delegate = self
            cell.configure(category: selectedCategory, schedule: selectedDays.isEmpty ? nil : selectedDays.joined(separator: ", "))
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension NewHabitModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 75
        case 1: return 150
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

// MARK: - CategoryScheduleCellDelegate
extension NewHabitModalViewController: CategoryScheduleCellDelegate {
    func didTapCategory() {
        selectedCategory = "Важное"
        updateScheduleCell()
    }
    
    func didTapSchedule() {
        let selectScheduleVC = SelectScheduleModalViewController()
        selectScheduleVC.delegate = self
        selectScheduleVC.modalPresentationStyle = .pageSheet
        selectScheduleVC.modalTransitionStyle = .coverVertical
        present(selectScheduleVC, animated: true)
    }
}

// MARK: - SelectScheduleDelegate
extension NewHabitModalViewController: SelectScheduleDelegate {
   
    
    func didSelectDays(_ days: [String]) {
        selectedDays = days
        updateScheduleCell()
    }
}
