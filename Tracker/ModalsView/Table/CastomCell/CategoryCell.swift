import UIKit

final class CategoryCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle("Категория")
    
    private lazy var categoryLabel = UILabel.ypSubtitleCell()
    
    private lazy var arrowImageView = UIImageView.ypArrow()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = UIColor.ypBackground
        layer.cornerRadius = 16
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(arrowImageView)
        selectionStyle = .default
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // categoryLabel
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            // arrowImageView
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            arrowImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25)
        ])
    }
    
    // MARK: - Configure
    func configureCategory(_ text: String?) {
        if let text = text, !text.isEmpty {
            categoryLabel.text = text
            categoryLabel.isHidden = false
        } else {
            categoryLabel.text = nil
            categoryLabel.isHidden = true
        }
    }
}
