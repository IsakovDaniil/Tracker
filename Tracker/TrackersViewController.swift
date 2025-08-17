import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var topStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
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
        return button
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
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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

