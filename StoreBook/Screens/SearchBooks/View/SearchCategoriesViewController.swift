import UIKit

struct ConstantsForCell {
    static let topAnchor: CGFloat = 4
    static let leadingAnchor: CGFloat = 20
    static let trailingAnchor: CGFloat = -20
    static let bottomAnchor: CGFloat = -20
    static let interSpacing: CGFloat = 8
    static let widthAnchorForIW: CGFloat = 95
    static let widthMultiplier: CGFloat = 145/95
}

final class SearchCategoriesViewController: UITableViewController {
    
    var category = ""
    private var viewModel = SearchViewModel()
    
    private lazy var activityIndicator = BookLoadIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registeredCell()
        title = category
        setConstraints()
        viewModel.fetchData(with: category)
  
        setupBindings()
    }
    
    private func registeredCell() {
        view.addSubview(activityIndicator)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 170
        tableView.register(SearchCategoriesCell.self, forCellReuseIdentifier: SearchCategoriesCell.cellID)
    }
    
    private func setupBindings() {
        viewModel.$tableData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.activityIndicator.isHidden = true
            }
            .store(in: &viewModel.cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.isHidden = false
                } else {
                    self?.activityIndicator.isHidden = true
                }
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150)
    
        ])
    }
}

extension SearchCategoriesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCategoriesCell.cellID, for: indexPath) as? SearchCategoriesCell else { return UITableViewCell() }
        let searchedCategoryBook = viewModel.tableData[indexPath.row]
        cell.configure(with: searchedCategoryBook)
        return cell
    }
}


