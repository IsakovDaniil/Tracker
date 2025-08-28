import UIKit

final class NewEventModalViewController: UIViewController {
    
    let handler = ModalHandler()
    
    // MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle("Новое нерегулярное событие")
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
//        table.register(NameInputCell.self, forCellReuseIdentifier: "NameInputCell")
        table.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
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
}

// MARK: - UITableViewDataSource
extension NewEventModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameInputCell", for: indexPath) as! NameInputCell
            return cell
        case 1:
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension NewEventModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2:
            return 75
        case 1:
            return 24
        default:
            return UITableView.automaticDimension
        }
    }
}
