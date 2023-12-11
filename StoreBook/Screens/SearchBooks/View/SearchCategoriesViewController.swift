import UIKit

struct ConstantsSearch {
    static let verticalSpacing: CGFloat = 4
    static let horizontalSpacing: CGFloat = 20
    static let interSpacing: CGFloat = 8
    static let rowHeight: CGFloat = 160
}

final class SearchCategoriesViewController: UITableViewController {
    
    var category: String

    private var viewModel = SearchViewModel()
    
    private lazy var activityIndicator = BookLoadIndicator()

// Категория назначается при инициализации
    init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registeredCell()
        title = category
        setActivityIndicator()
        viewModel.fetchData(with: category)
  
        setupBindings()
    }

    // нарушение S
    private func registeredCell() {
 
        
        tableView.rowHeight = ConstantsSearch.rowHeight
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchCategoriesCell.self, forCellReuseIdentifier: SearchCategoriesCell.cellID)
    }
    
    private func setupBindings() {
        viewModel.$tableData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                //self?.activityIndicator.isHidden = true
            }
            .store(in: &viewModel.cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
//                if isLoading {
//                    self?.activityIndicator.isHidden = false
//                } else {
//                    self?.activityIndicator.isHidden = true
//                }
                    //add
                  self?.activityIndicator.isHidden = isLoading
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setActivityIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
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


