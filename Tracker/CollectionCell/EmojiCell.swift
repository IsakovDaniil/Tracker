import UIKit

final class EmojiCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EmojiCell"
    
    //MARK: - UI Element
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setupCell() {
        contentView.layer.cornerRadius = 16
    }
    
    private func setupView() {
        contentView.addSubview(emojiLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7)
        ])
    }
    
    // MARK: - Configuration
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        
        contentView.backgroundColor = isSelected ? UIColor.ypLightGray : .clear
    }
}
