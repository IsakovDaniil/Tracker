import UIKit

final class AddCategoryModalViewController: UIViewController {
    private let titleLabel = UILabel.ypTitle("Категория")
    
    private lazy var stubStack = UIStackView.stubStack()
    
    private let stubImageView = UIImageView.stubImage()
    
    private let stubLabel = UILabel.stubLabel(withText: "Привычки и события можно объединить по смыслу")
    
    private lazy var optionsTableView = UITableView.makeOptionsTableView(
        dataSource: self,
        delegate: self,
        separatorStyle: .none
    )
    
    private lazy var addCategoryButton = UIButton.ypAddModalButton(
        title: "Добавить категорию",
        target: self,
        action: #selector(addCategoryButtonTapped)
    )
    
    // MARK: - Data
    private var categories: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        updateUI()
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
        
        view.addSubview(optionsTableView)
        view.addSubview(addCategoryButton)
        
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
        let hasCategories = !categories.isEmpty
        stubStack.isHidden = hasCategories
        optionsTableView.isHidden = !hasCategories
    }
    
    private func addCategory(_ categoryName: String) {
        categories.append(categoryName)
        updateUI()
        optionsTableView.reloadData()
    }
    
    @objc private func addCategoryButtonTapped() {
        let newCategoryVC = NewCategoryModalViewController()
        newCategoryVC.modalPresentationStyle = .pageSheet
        newCategoryVC.modalTransitionStyle = .coverVertical
        
        // Передаем замыкание для обработки новой категории
        newCategoryVC.onCategoryAdded = { [weak self] categoryName in
            self?.addCategory(categoryName)
        }
        
        present(newCategoryVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AddCategoryModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionCell else {
            return UITableViewCell()
        }
        
        let categoryName = categories[indexPath.row]
        cell.configure(title: categoryName, subtitle: nil)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddCategoryModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Здесь можно добавить логику выбора категории
    }
}
