import Foundation
import UIKit

final class FilterModalViewController: UIViewController {
    // MARK: - Properties
    private let filterOptions = [
        "Все трекеры",
        "Трекеры на сегодня",
        "Завершенные",
        "Не завершенные"
    ]
    
    private var selectedIndex: Int? = 0
    
    // MARK: - UI Elements
    private let titleLabel = UILabel.ypTitle("Фильтры")
    
    private lazy var filterTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        
        view.addSubview(titleLabel)
        view.addSubview(filterTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filterTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            filterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureAppearance(for cell: UITableViewCell, at indexPath: IndexPath) {
        let numberOfRows = filterTableView.numberOfRows(inSection: indexPath.section)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        
        if numberOfRows == 1 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            if indexPath.row == 0 {
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == numberOfRows - 1 {
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.layer.maskedCorners = []
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension FilterModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        let title = filterOptions[indexPath.row]
        cell.configure(title: title)
        cell.accessoryType = selectedIndex == indexPath.row ? .checkmark : .none
        cell.tintColor = UIColor.ypBlue
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FilterModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var indexPathsToReload: [IndexPath] = []
        
        // Добавляем старый выбранный индекс для обновления
        if let oldIndex = selectedIndex {
            indexPathsToReload.append(IndexPath(row: oldIndex, section: 0))
        }
        
        // Обновляем выбранный индекс
        selectedIndex = indexPath.row
        indexPathsToReload.append(indexPath)
        
        // Обновляем ячейки
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        
        // TODO: Здесь будет логика применения фильтра
        // Пока просто закрываем модалку после выбора
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        configureAppearance(for: cell, at: indexPath)
        
        if let cell = cell as? CategoryCell {
            let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.setSeparatorHidden(indexPath.row == lastRow)
        }
    }
}
