import UIKit

final class ColorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ColorCell"
    
    // MARK: UI Element
    private let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupCell() {
        layer.cornerRadius = 16
    }
    
    private func setupView() {
        contentView.addSubview(colorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
    }
    
    // MARK: - Configuration
    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        
        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = color.cgColor
            layer.borderColor = color.withAlphaComponent(0.3).cgColor
        } else {
            layer.borderWidth = .zero
        }
    }
}
