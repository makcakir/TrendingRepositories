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
    private var presentations: [TrendingRepositoryPresentation] = []
    private var isLoading = false
    
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
            DispatchQueue.main.async {
                self.applyChange(change)
            }
        }
    }
    
    func applyChange(_ change: TrendingRepositoriesViewModel.Change) {
        switch change {
        case .error:
            refreshControl.endRefreshing()
            isLoading = false
            errorView.isHidden = false
            retryAnimationView.play()
        case .items(let items):
            refreshControl.endRefreshing()
            isLoading = false
            tableView.isScrollEnabled = true
            presentations = items
            tableView.reloadData()
        case .loading:
            isLoading = true
            tableView.isScrollEnabled = false
            errorView.isHidden = true
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
        return isLoading ? 15 : presentations.count
    }
    
    func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(indexPath, type: TrendingRepositoryShimmerTableViewCell.self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(indexPath, type: TrendingRepositoryTableViewCell.self)
            let presentation = presentations[indexPath.row]
            cell.fill(presentation)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension TrendingRepositoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
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
}
