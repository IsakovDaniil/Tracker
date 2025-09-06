import UIKit

final class EmojiCell: UICollectionViewCell {
    
    //MARK: - UI Element
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        label.layer.cornerRadius = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setupView() {
        contentView.addSubview(emojiLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Configuration
    private func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        
        if isSelected {
            backgroundColor = UIColor.ypLightGray
        } else {
            backgroundColor = .clear
        }
    }
}
