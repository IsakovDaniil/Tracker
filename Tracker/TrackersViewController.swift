import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.addTracker.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.ypBlack
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dataButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "14.12.22"
        config.baseForegroundColor = UIColor.ypTextBlack
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 5.5, bottom: 6, trailing: 5.5)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.backgroundColor = UIColor.ypBackgroundLight
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(dataButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Поиск"
        bar.searchBarStyle = .minimal
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private lazy var stubStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.dizzyStar
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhite
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.addSubview(topStack)
        topStack.addArrangedSubview(addButton)
        topStack.addArrangedSubview(dataButton)
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(stubStack)
        stubStack.addArrangedSubview(stubImageView)
        stubStack.addArrangedSubview(stubLabel)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 230)
        ])
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        print("Нажал на +")
    }
    
    @objc private func dataButtonTapped() {
        print("Нажал на Data")
    }
    
}

