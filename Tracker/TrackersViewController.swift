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
        let button = UIButton()
        button.setImage(UIImage.addTracker, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dataButton: UIButton = {
        let button = UIButton()
        button.setTitle("14.12.22", for: .normal)
        button.setTitleColor(UIColor.ypBlack, for: .normal)
        button.backgroundColor = UIColor.ypBackgroundLight
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(dataButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhite
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.addSubview(topStack)
        topStack.addArrangedSubview(addButton)
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        print("Нажал")
    }
    
    @objc private func dataButtonTapped() {
        
    }
    
}

