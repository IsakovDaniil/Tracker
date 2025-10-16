import UIKit

final class AddCategoryModalViewController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel = UILabel.ypTitle(
        R.string.localizable.categoryTitle()
    )
    
    private lazy var stubStack = UIStackView.stubStack()
    
    private let stubImageView = UIImageView.stubImage()
    
    private let stubLabel = UILabel.stubLabel(
        withText: R.string.localizable.categoryStubText()
    )
    
    private lazy var optionsTableView = UITableView.makeOptionsTableView(
        dataSource: self,
        delegate: self,
        separatorStyle: .none,
        reuseIdentifier: CategoryCell.reuseIdentifier,
        cellClass: CategoryCell.self
    )
    
    private lazy var addCategoryButton = UIButton.ypAddModalButton(
        title: R.string.localizable.categoryAddButton(),
        target: self,
        action: #selector(addCategoryButtonTapped)
    )
    
    // MARK: - ViewModel
    private let viewModel: CategoryListViewModel
    
    // MARK: - Callbacks
    var onCategorySelected: ((String) -> Void)?
    
    // MARK: - Init
    init(viewModel: CategoryListViewModel = CategoryListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = CategoryListViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        bindViewModel()
        viewModel.fetchCategories()
    }
    
    // MARK: - Private methods
    private func bindViewModel() {
        viewModel.onCategoriesUpdated = { [weak self] in
            self?.optionsTableView.reloadData()
            self?.updateUI()
        }
        viewModel.onCategorySelected = onCategorySelected
    }
    
    private func setupView() {
        view.layer.masksToBounds = false
        view.layer.cornerRadius = NewEventConstants.Layout.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor.ypWhite
        
        view.addSubview(titleLabel)
        view.addSubview(stubStack)
        stubStack.addArrangedSubview(stubImageView)
        stubStack.addArrangedSubview(stubLabel)
        
        view.addSubview(optionsTableView)
        view.addSubview(addCategoryButton)
        
        optionsTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stubStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
            
            optionsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            optionsTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func updateUI() {
        let hasCategories = !viewModel.categories.isEmpty
        stubStack.isHidden = hasCategories
        optionsTableView.isHidden = !hasCategories
    }
    
    private func configureAppearance(for cell: UITableViewCell, at indexPath: IndexPath) {
        let numberOfRows = optionsTableView.numberOfRows(inSection: indexPath.section)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        if numberOfRows == 1 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            if indexPath.row == 0 {
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == numberOfRows - 1 {
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.layer.maskedCorners = []
            }
        }
    }
    
    @objc private func addCategoryButtonTapped() {
        let newCategoryVC = NewCategoryModalViewController()
        newCategoryVC.modalPresentationStyle = .pageSheet
        newCategoryVC.modalTransitionStyle = .coverVertical
        
        newCategoryVC.onCategoryAdded = { [weak self] categoryName in
            self?.viewModel.addCategory(name: categoryName)
        }
        
        present(newCategoryVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AddCategoryModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        let title = viewModel.categoryTitle(at: indexPath.row)
        cell.configure(title: title)
        cell.accessoryType = viewModel.isSelected(at: indexPath.row) ? .checkmark : .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddCategoryModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var indexPathsToReload: [IndexPath] = []
        if let oldIndex = viewModel.selectedIndex {
            indexPathsToReload.append(IndexPath(row: oldIndex, section: 0))
        }
        
        let shouldDismiss = viewModel.selectCategory(at: indexPath.row)
        if viewModel.selectedIndex == indexPath.row {
            indexPathsToReload.append(indexPath)
        }
        
        if !indexPathsToReload.isEmpty {
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
        
        if shouldDismiss {
            dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        configureAppearance(for: cell, at: indexPath)
        if let cell = cell as? CategoryCell {
            let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.setSeparatorHidden(indexPath.row == lastRow)
        }
    }
}
