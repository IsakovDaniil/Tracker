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
    
    private lazy var categoryStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [categoryTitleLabel, categoryValueLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var scheduleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [scheduleTitleLabel, scheduleValueLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var categoryHorizontalStack: UIStackView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView(arrangedSubviews: [categoryStack, spacer, categoryArrowImageView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var scheduleHorizontalStack: UIStackView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView(arrangedSubviews: [scheduleStack, spacer, scheduleArrowImageView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [categoryHorizontalStack, separatorLine, scheduleHorizontalStack])
        stack.axis = .vertical
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
        contentView.addSubview(mainStack)
        contentView.addSubview(categoryButton)
        contentView.addSubview(scheduleButton)
        categoryValueLabel.isHidden = true
        scheduleValueLabel.isHidden = true
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            categoryButton.topAnchor.constraint(equalTo: categoryHorizontalStack.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: categoryHorizontalStack.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: categoryHorizontalStack.trailingAnchor),
            categoryButton.bottomAnchor.constraint(equalTo: categoryHorizontalStack.bottomAnchor),
            
            scheduleButton.topAnchor.constraint(equalTo: scheduleHorizontalStack.topAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: scheduleHorizontalStack.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: scheduleHorizontalStack.trailingAnchor),
            scheduleButton.bottomAnchor.constraint(equalTo: scheduleHorizontalStack.bottomAnchor)
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
    
    //MARK: - Actions
    @objc private func categoryTapped() {
        delegate?.didTapCategory()
    }
    
    @objc private func scheduleTapped() {
        delegate?.didTapSchedule()
    }
}

