import UIKit

final class AddCategoryModalViewController: UIViewController {
    private let titleLabel = UILabel.ypTitle("Категория")
    
    private lazy var stubStack = UIStackView.stubStack()
    
    private let stubImageView = UIImageView.stubImage()
    
    private let stubLabel = UILabel.stubLabel(withText: "Привычки и события можно объединить по смыслу")
    
    private lazy var addCategoryButton = UIButton.ypAddModalButton(
        title: "Добавить категорию",
        target: self,
        action: #selector(addCategoryButtonTapped)
    )
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = NewEventConstants.Layout.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        
        view.addSubview(titleLabel)
        view.addSubview(stubStack)
        stubStack.addArrangedSubview(stubImageView)
        stubStack.addArrangedSubview(stubLabel)
        
        view.addSubview(addCategoryButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func addCategoryButtonTapped() {
        let newCategoryVC = NewCategoryModalViewController()
        newCategoryVC.modalPresentationStyle = .pageSheet
        newCategoryVC.modalTransitionStyle = .coverVertical
        present(newCategoryVC, animated: true)
    }
}
