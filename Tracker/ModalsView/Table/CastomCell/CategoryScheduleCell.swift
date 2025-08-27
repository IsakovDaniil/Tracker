import UIKit

protocol CategoryScheduleCellDelegate: AnyObject {
    func didTapCategory()
    func didTapSchedule()
}

final class CategoryScheduleCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var categoryTitleLabel = UILabel.ypTitle("Категория")
    private lazy var categoryValueLabel = UILabel.ypSubtitleCell()
    private lazy var categoryArrowImageView = UIImageView.ypArrow()
    
    private lazy var scheduleTitleLabel = UILabel.ypTitle("Расписание")
    private lazy var scheduleValueLabel = UILabel.ypSubtitleCell()
    private lazy var scheduleArrowImageView = UIImageView.ypArrow()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // --- SCHEDULE ---
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: CategoryScheduleCellDelegate?
    
    // MARK: - Init
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
        layer.cornerRadius = 16
        selectionStyle = .none
        contentView.addSubview(categoryTitleLabel)
        contentView.addSubview(categoryValueLabel)
        contentView.addSubview(categoryArrowImageView)
        contentView.addSubview(separatorLine)
        contentView.addSubview(scheduleTitleLabel)
        contentView.addSubview(scheduleValueLabel)
        contentView.addSubview(scheduleArrowImageView)
        contentView.addSubview(categoryButton)
        contentView.addSubview(scheduleButton)
        categoryValueLabel.isHidden = true
        scheduleValueLabel.isHidden = true
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // --- CATEGORY ---
            categoryTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            categoryTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            categoryValueLabel.topAnchor.constraint(equalTo: categoryTitleLabel.bottomAnchor, constant: 2),
            categoryValueLabel.leadingAnchor.constraint(equalTo: categoryTitleLabel.leadingAnchor),
            categoryValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: categoryArrowImageView.leadingAnchor, constant: -8),
            
            categoryArrowImageView.centerYAnchor.constraint(equalTo: categoryTitleLabel.centerYAnchor),
            categoryArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // --- SEPARATOR ---
            separatorLine.topAnchor.constraint(equalTo: categoryValueLabel.bottomAnchor, constant: 16),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            // --- SCHEDULE ---
            scheduleTitleLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 16),
            scheduleTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            scheduleValueLabel.topAnchor.constraint(equalTo: scheduleTitleLabel.bottomAnchor, constant: 2),
            scheduleValueLabel.leadingAnchor.constraint(equalTo: scheduleTitleLabel.leadingAnchor),
            scheduleValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: scheduleArrowImageView.leadingAnchor, constant: -8),
            
            scheduleArrowImageView.centerYAnchor.constraint(equalTo: scheduleTitleLabel.centerYAnchor),
            scheduleArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // --- BOTTOM ---
            scheduleValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: categoryTitleLabel.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: categoryTitleLabel.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: categoryArrowImageView.trailingAnchor),
            categoryButton.bottomAnchor.constraint(equalTo: categoryValueLabel.bottomAnchor),
            
            // Кнопка расписания
            scheduleButton.topAnchor.constraint(equalTo: scheduleTitleLabel.topAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: scheduleTitleLabel.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: scheduleArrowImageView.trailingAnchor),
            scheduleButton.bottomAnchor.constraint(equalTo: scheduleValueLabel.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(category: String?, schedule: String?) {
        if let category = category, !category.isEmpty {
            categoryValueLabel.text = category
            categoryValueLabel.isHidden = false
        } else {
            categoryValueLabel.text = nil
            categoryValueLabel.isHidden = true
        }
        
        if let schedule = schedule, !schedule.isEmpty {
            scheduleValueLabel.text = schedule
            scheduleValueLabel.isHidden = false
        } else {
            scheduleValueLabel.text = nil
            scheduleValueLabel.isHidden = true
        }
    }
    
    // MARK: - Actions
    @objc private func categoryTapped() {
        delegate?.didTapCategory()
    }
    
    @objc private func scheduleTapped() {
        delegate?.didTapSchedule()
    }
}
