import UIKit

protocol EmojiColorSelectionDelegate: AnyObject {
    func didSelectEmoji(_ emoji: String)
    func didSelectColor(_ color: UIColor)
}

final class EmojiColorCollectionManager: NSObject {
    
    // MARK: - Properties
    weak var delegate: EmojiColorSelectionDelegate?
    private let model = EmojiColorModel()
    
    private var selectedEmojiIndex: Int?
    private var selectedColorIndex: Int?
    
    // MARK: - Pubilic Methods
    func configure(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        
        collectionView.register(TrackerHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerHeaderView.reuseIdentifier)
    }
    
    func setSelectedEmoji(_ emoji: String) {
        selectedEmojiIndex = model.emojies.firstIndex(of: emoji)
    }
    
    func getSelectedEmoji() -> String? {
        guard let index = selectedEmojiIndex else { return nil }
        return model.emojies[index]
    }
    
    func setSelectedColor(_ color: UIColor) {
        selectedColorIndex = model.colors.firstIndex(of: color)
    }
    
    func getSelectedColor() -> UIColor? {
        guard let index = selectedColorIndex else { return nil }
        return model.colors[index]
    }
}

// MARK: - UICollectionViewDataSource
extension EmojiColorCollectionManager: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return model.emojies.count
        case 1: return model.colors.count
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else {
                return UICollectionViewCell()
            }
            let emoji = model.emojies[indexPath.item]
            let isSelected = selectedEmojiIndex == indexPath.item
            cell.configure(with: emoji, isSelected: isSelected)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else {
                return UICollectionViewCell()
            }
            let color = model.colors[indexPath.item]
            let isSelected = selectedColorIndex == indexPath.item
            cell.configure(with: color, isSelected: isSelected)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerHeaderView.reuseIdentifier,
                for: indexPath
              ) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        
        switch indexPath.section {
        case 0: header.configure(with: "Emoji")
        case 1: header.configure(with: "Цвет")
        default: break
        }
        
        return header
    }
}



// MARK: - UICollectionViewDelegate
extension EmojiColorCollectionManager: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if selectedEmojiIndex == indexPath.item {
                selectedEmojiIndex = nil
                collectionView.reloadItems(at: [indexPath])
                return
            }
            
            let previousIndex = selectedEmojiIndex
            
            selectedEmojiIndex = indexPath.item
            
            var indexPathsToReload = [indexPath]
            if let previous = previousIndex {
                indexPathsToReload.append(IndexPath(item: previous, section: 0))
            }
            collectionView.reloadItems(at: indexPathsToReload)
            
            let selectedEmoji = model.emojies[indexPath.item]
            delegate?.didSelectEmoji(selectedEmoji)
            
        case 1:
            if selectedColorIndex == indexPath.item {
                selectedColorIndex = nil
                collectionView.reloadItems(at: [indexPath])
                return
            }
            
            let previousIndex = selectedColorIndex
            
            selectedColorIndex = indexPath.item
            
            var indexPathsToReload = [indexPath]
            if let previous = previousIndex {
                indexPathsToReload.append(IndexPath(item: previous, section: 1))
            }
            collectionView.reloadItems(at: indexPathsToReload)
            
            let selectedColor = model.colors[indexPath.item]
            delegate?.didSelectColor(selectedColor)
            
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EmojiColorCollectionManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 6
        let spacing: CGFloat = 5
        let totalSpacing = (itemsPerRow - 1) * spacing
        let insets: CGFloat = 36
        let width = (collectionView.bounds.width - totalSpacing - insets) / itemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
