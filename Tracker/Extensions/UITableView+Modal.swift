import UIKit

extension UITableView {
    static func makeOptionsTableView<Cell: UITableViewCell>(
        dataSource: UITableViewDataSource,
        delegate: UITableViewDelegate,
        separatorStyle: UITableViewCell.SeparatorStyle = .none,
        reuseIdentifier: String = "OptionCell",
        cellClass: Cell.Type = OptionCell.self
    ) -> UITableView {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.separatorStyle = separatorStyle
        tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
}
