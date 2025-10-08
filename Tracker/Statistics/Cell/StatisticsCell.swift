import UIKit

final class StatisticsCell: UITableViewCell {
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(titleLabel)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 5)
        ])
        
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.cornerRadius = 10
    }
    
    func configure(withNumber number: String, title: String) {
        numberLabel.text = number
        titleLabel.text = title
    }
}
