import UIKit

final class TrackerHeaderView: UICollectionReusableView {
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TrackerHeaderViewConstants.Typography.titleLabelFontSize, weight: TrackerHeaderViewConstants.Typography.titleLabelWeight)
        label.textColor = UIColor.ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: TrackerHeaderViewConstants.Layout.titleLabelLeadingInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: TrackerHeaderViewConstants.Layout.titleLabelTrailingInset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: TrackerHeaderViewConstants.Layout.titleLabelBottomInset)
        ])
    }
    
    // MARK: - Configuration
    func configure(with title: String) {
        titleLabel.text = title
    }
}
