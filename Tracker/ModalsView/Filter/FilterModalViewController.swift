import Foundation
import UIKit

protocol FilterModalDelegate: AnyObject {
    func didSelectFilter(_ filterType: TrackerFilterType)
}

final class FilterModalViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: FilterModalDelegate?
    private var selectedFilterType: TrackerFilterType
    
    // MARK: - UI Elements
    private let titleLabel = UILabel.ypTitle(
        R.string.localizable.trackersFilters()
    )
    
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
    
    // MARK: - Init
    init(currentFilter: TrackerFilterType = .allTrackers) {
        self.selectedFilterType = currentFilter
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
        return TrackerFilterType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        let filterType = TrackerFilterType.allCases[indexPath.row]
        cell.configure(title: filterType.title)
        
        let shouldShowCheckmark = filterType.shouldShowCheckmark && selectedFilterType == filterType
        cell.accessoryType = shouldShowCheckmark ? .checkmark : .none
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
        
        let newFilterType = TrackerFilterType.allCases[indexPath.row]
        
        if newFilterType.shouldShowCheckmark || selectedFilterType.shouldShowCheckmark {
            var indexPathsToReload: [IndexPath] = []
            
            if selectedFilterType.shouldShowCheckmark {
                indexPathsToReload.append(IndexPath(row: selectedFilterType.rawValue, section: 0))
            }
            
            if newFilterType.shouldShowCheckmark {
                indexPathsToReload.append(indexPath)
            }
            
            selectedFilterType = newFilterType
            
            if !indexPathsToReload.isEmpty {
                tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            }
        } else {
            selectedFilterType = newFilterType
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.delegate?.didSelectFilter(newFilterType)
            self.dismiss(animated: true)
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
