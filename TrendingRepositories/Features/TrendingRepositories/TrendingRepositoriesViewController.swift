//
//  TrendingRepositoriesViewController.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import UIKit

class TrendingRepositoriesViewController: UITableViewController {
    
    var viewModel: TrendingRepositoriesViewModel!
    private var presentations: [TrendingRepositoryPresentation] = []
    
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
        
        tableView.registerNibReusableCell(TrendingRepositoryTableViewCell.self)
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
            presentations = items
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
        return presentations.count
    }
    
    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath, type: TrendingRepositoryTableViewCell.self)
        let presentation = presentations[indexPath.row]
        cell.fill(presentation)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TrendingRepositoriesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? TrendingRepositoryTableViewCell {
            let presentation = presentations[indexPath.row]
            presentation.isExpanded.toggle()
            cell.detailStackView.isHidden.toggle()
            UIView.animate(withDuration: 0.3) {
                self.tableView.performBatchUpdates(nil)
            }
        }
    }
}
