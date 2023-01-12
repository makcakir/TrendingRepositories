//
//  TrendingRepositoriesViewController.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import UIKit

class TrendingRepositoriesViewController: UITableViewController {
    
    var viewModel: TrendingRepositoriesViewModel!
    private var items: [TrendingRepositoryPresentation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        bindViewModel()
        viewModel.fetchRepositories()
    }
}

// MARK: - Helpers

private extension TrendingRepositoriesViewController {
    
    func setupSubviews() {
        title = "trending".localized()
    }
    
    func bindViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            DispatchQueue.main.async {
                self.applyChange(change)
            }
        }
    }
    
    func applyChange(_ change: TrendingRepositoriesViewModel.Change) {
        switch change {
        case .error:
            break
        case .items(let items):
            self.items = items
            tableView.reloadData()
        case .loading:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension TrendingRepositoriesViewController {
    
    override func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "identifier")
        }
        let item = items[indexPath.row]
        cell?.textLabel?.text = item.title
        cell?.detailTextLabel?.text = item.description
        return cell ?? UITableViewCell()
    }
}
