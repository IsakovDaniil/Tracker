import UIKit

final class WeekdaysCell: UITableViewCell {
    static let identifier = "WeekdaysCell"
    
    // MARK - UI Elements
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: WeekdaysCellConstants.Typography.dayLabelFontSize,
                                       weight: WeekdaysCellConstants.Typography.dayLabelFontWeight)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let toggleSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.onTintColor = UIColor.ypBlue
        return switchView
    }()

    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dayLabel)
        contentView.addSubview(toggleSwitch)
        backgroundColor = .clear
        self.selectionStyle = .none
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: WeekdaysCellConstants.Layout.leadingInset),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: WeekdaysCellConstants.Layout.trailingInset),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with title: String, isOn: Bool) {
        dayLabel.text = title
        toggleSwitch.isOn = isOn
    }
}
