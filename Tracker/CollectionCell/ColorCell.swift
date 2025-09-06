import UIKit

final class ColorCell: UICollectionViewCell {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupCell() {
        layer.cornerRadius = 16
    }
    
    // MARK: - Configuration
    private func configure(with color: UIColor, isSelected: Bool) {
        backgroundColor = color
        
        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = color.cgColor
        } else {
            layer.borderWidth = .zero
        }
    }
}
