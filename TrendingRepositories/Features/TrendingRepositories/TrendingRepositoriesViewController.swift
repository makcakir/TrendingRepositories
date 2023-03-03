//
//  TrendingRepositoriesViewController.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Lottie
import UIKit

final class TrendingRepositoriesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var retryAnimationView: LottieAnimationView!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var errorDescriptionLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    private let refreshControl = UIRefreshControl()
    
    var viewModel: TrendingRepositoriesViewModel!
    private var presentationTypes: [TrendingRepositoriesViewModel.PresentationType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        bindViewModel()
        refreshData()
    }
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        refreshData()
    }
}

// MARK: - Helpers

private extension TrendingRepositoriesViewController {
    
    enum Const {
        static let animationSpeed: CGFloat = 0.5
    }
    
    func setupSubviews() {
        title = "trending".localized()
        
        tableView.registerNibReusableCell(TrendingRepositoryShimmerTableViewCell.self)
        tableView.registerNibReusableCell(TrendingRepositoryTableViewCell.self)
        
        retryAnimationView.contentMode = .scaleAspectFit
        retryAnimationView.loopMode = .loop
        retryAnimationView.animationSpeed = Const.animationSpeed
        
        errorMessageLabel.text = "errorMessage".localized()
        
        errorDescriptionLabel.text = "errorDescription".localized()
        
        retryButton.setTitle("retry".localized(), for: .normal)
        retryButton.applyRoundedRectStyling()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        viewModel.fetchRepositories()
    }
    
    func bindViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            self.applyChange(change)
        }
    }
    
    func applyChange(_ change: TrendingRepositoriesViewModel.Change) {
        switch change {
        case .error:
            refreshControl.endRefreshing()
            errorView.isHidden = false
            retryAnimationView.play()
        case .items(let items):
            refreshControl.endRefreshing()
            tableView.isScrollEnabled = true
            presentationTypes = items
            tableView.reloadData()
        case .loading(let items):
            tableView.isScrollEnabled = false
            errorView.isHidden = true
            presentationTypes = items
            retryAnimationView.pause()
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension TrendingRepositoriesViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        return presentationTypes.count
    }
    
    func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch presentationTypes[indexPath.row] {
        case .data(let presentation):
            let cell = tableView.dequeueReusableCell(indexPath, type: TrendingRepositoryTableViewCell.self)
            cell.fill(presentation)
            return cell
        case .loading:
            return tableView.dequeueReusableCell(indexPath, type: TrendingRepositoryShimmerTableViewCell.self)
        }
    }
}

// MARK: - UITableViewDelegate

extension TrendingRepositoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch presentationTypes[indexPath.row] {
        case .data(let presentation):
            if let cell = self.tableView.cellForRow(at: indexPath) as? TrendingRepositoryTableViewCell {
                presentation.isExpanded.toggle()
                cell.detailStackView.isHidden.toggle()
                UIView.animate(withDuration: 0.3) {
                    self.tableView.performBatchUpdates(nil)
                }
            }
        case .loading:
            // Left blank intentionally!
            break
        }
    }
}
