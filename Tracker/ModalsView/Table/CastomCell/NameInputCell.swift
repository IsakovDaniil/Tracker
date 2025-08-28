import UIKit

final class NameInputCell: UITableViewCell {
    lazy var textField = UITextField.ypTitleTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        setupConstraints()
        selectionStyle = .none
        backgroundColor = UIColor.ypBackground
        layer.cornerRadius = 16
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
}
