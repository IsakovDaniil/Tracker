import Foundation
import UIKit

final class CategoryCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "CategoryCell"
    private var bottomSeparatorHeightConstraint: NSLayoutConstraint!
    private var pixelHeight: CGFloat { 1.5 / UIScreen.main.scale }
    
    // MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle(OptionCellConstants.Strings.emptySubtitle)
    
    private let bottomSeparator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .separator
        v.isOpaque = true
        return v
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        backgroundColor = UIColor.ypBackground
        selectionStyle = .none
        accessoryType = .none
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(bottomSeparator)
        bottomSeparatorHeightConstraint = bottomSeparator.heightAnchor.constraint(equalToConstant: pixelHeight)
        
        contentView.addSubview(titleLabel)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: OptionCellConstants.Layout.titleLabelLeadingInset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: OptionCellConstants.Layout.titleLabelTrailingInset),
            
            bottomSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomSeparatorHeightConstraint,
            
            contentView.heightAnchor.constraint(equalToConstant: OptionCellConstants.Layout.contentViewHeight)
        ])
    }
    
    // MARK: - Separator Configuration
    func setSeparatorHidden(_ hidden: Bool) {
        bottomSeparator.isHidden = hidden
    }
    
    func setSeparatorAppearance(color: UIColor = .separator, height: CGFloat? = nil) {
        bottomSeparator.backgroundColor = color
        bottomSeparatorHeightConstraint.constant = height ?? pixelHeight
        setNeedsLayout()
    }
    
    // MARK: - Configuration
    func configure(title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
