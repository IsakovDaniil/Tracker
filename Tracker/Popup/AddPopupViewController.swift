import UIKit

final class AddPopupViewController: UIViewController {
    //MARK: - UI Elements
    private lazy var titleLabel = UILabel.ypTitle("Создание трекера")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = UIColor.ypWhite
        view.addSubview(titleLabel)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
    }
}
