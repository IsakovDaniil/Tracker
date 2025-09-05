import UIKit

final class OptionCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle(OptionCellConstants.Strings.emptySubtitle)
    private lazy var subtitleLabel = UILabel.ypSubtitleCell()
    
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
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: OptionCellConstants.Layout.titleLabelTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: OptionCellConstants.Layout.titleLabelLeadingInset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: OptionCellConstants.Layout.titleLabelTrailingInset),
            
            // subtitleLabel
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: OptionCellConstants.Layout.subtitleLabelTopInset),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: OptionCellConstants.Layout.subtitleLabelLeadingInset),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: OptionCellConstants.Layout.subtitleLabelTrailingInset),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: OptionCellConstants.Layout.subtitleLabelBottomInset),
            
            contentView.heightAnchor.constraint(equalToConstant: OptionCellConstants.Layout.contentViewHeight)
        ])
    }
    
    // MARK: - Configure
    func configure(title: String, subtitle: String?) {
        titleLabel.text = title
        if let subtitle = subtitle, !subtitle.isEmpty {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.text = nil
            subtitleLabel.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        subtitleLabel.isHidden = false
    }
}
