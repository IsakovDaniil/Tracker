import UIKit

final class AddCategoryModalViewController: UIViewController {
    private let titleLabel = UILabel.ypTitle("Категория")
    
    private lazy var stubStack = UIStackView.stubStack()
    
    private let stubImageView = UIImageView.stubImage()
    
    private let stubLabel = UILabel.stubLabel(withText: TrackersViewConstants.Strings.stubLabelText)
    
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
        
    }
    
    private func setupConstraints() {
        
    }
    
    @objc private func addCategoryButtonTapped() {
        
    }
}
