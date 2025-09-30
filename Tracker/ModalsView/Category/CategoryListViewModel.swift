import UIKit

// MARK: - ViewModel
final class CategoryListViewModel {
    // MARK: - Properties
    private let store: TrackerCategoryStoreProtocol
    private(set) var categories: [TrackerCategory] = []
    private(set) var selectedIndex: Int?
    
    // MARK: - Callbacks
    var onCategoriesUpdated: (() -> Void)?
    var onCategorySelected: ((String) -> Void)?
    
    // MARK: - Init
    init(store: TrackerCategoryStoreProtocol = TrackerCategoryStore()) {
        self.store = store
        if let delegateStore = store as? TrackerCategoryStore {
            delegateStore.delegate = self
        }
    }
    
    // MARK: - Public Methods
    func fetchCategories() {
        do {
            categories = try store.fetchAllCategories()
            onCategoriesUpdated?()
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
    
    func addCategory(name: String) {
        do {
            try store.addCategory(TrackerCategory(title: name, trackers: []))
        } catch {
            print("Error adding category: \(error)")
        }
    }
    
    func categoryTitle(at index: Int) -> String {
        guard index < categories.count else { return "" }
        return categories[index].title
    }
    
    func isSelected(at index: Int) -> Bool {
        return selectedIndex == index
    }
    
    func selectCategory(at index: Int) -> Bool {
        if selectedIndex == index {
            selectedIndex = nil
            return false
        } else {
            selectedIndex = index
            let selectedTitle = categories[index].title
            onCategorySelected?(selectedTitle)
            return true
        }
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension CategoryListViewModel: TrackerCategoryStoreDelegate {
    func didUpdateCategories() {
        fetchCategories()
    }
}
