import UIKit

extension UITableView {
    static func makeOptionsTableView(
        dataSource: UITableViewDataSource,
        delegate: UITableViewDelegate,
        separatorStyle: UITableViewCell.SeparatorStyle = .none
    ) -> UITableView {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.separatorStyle = separatorStyle
        tableView.register(OptionCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
}
