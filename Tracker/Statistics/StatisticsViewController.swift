import UIKit

final class StatisticsViewController: UIViewController {
    
    private lazy var stubStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = TrackersViewConstants.Layout.stubStackSpacing
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let stubImageView = UIImageView.stubImage()
    
    private lazy var stubLabel = UILabel.stubLabel(withText: "Анализировать пока нечего")
    
    
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupConstraints()
    }
    
    private func setupNavigation() {
        title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        stubImageView.image = .stubEmoji
        
        view.addSubview(stubStack)
        stubStack.addArrangedSubview(stubImageView)
        stubStack.addArrangedSubview(stubLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 246),
        ])
    }
}
