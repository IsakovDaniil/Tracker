import UIKit

final class AddModalViewController: UIViewController {
    //MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle("Создание трекера")
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var addHabitButton = UIButton.ypAddModalButton(title: "Привычка",
                                                                target: self,
                                                                action: #selector(addHabitButtonTapped))
    
    private lazy var addEventButton = UIButton.ypAddModalButton(title: "Нерегулярное событие",
                                                                target: self,
                                                                action: #selector(addEventButtonTapped))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        view.layer.cornerRadius = 12
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Action
    @objc private func addHabitButtonTapped() {
        
    }
    
    @objc private func addEventButtonTapped() {
        
    }
}
