//
//  TrendingRepositoriesViewController.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Lottie
import SwifterSwift
import UIKit

final class TrendingRepositoriesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var retryAnimationView: LottieAnimationView!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var errorDescriptionLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    private let refreshControl = UIRefreshControl()
    
    private let viewModel: TrendingRepositoriesViewModel
    private var presentationTypes: [TrendingRepositoriesViewModel.PresentationType] = []
    
    init(viewModel: TrendingRepositoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        static let lottieAnimationSpeed: CGFloat = 0.5
        static let animationDuration: CGFloat = 0.3
    }
    
    func setupSubviews() {
        title = "trendingRepositories".localized()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(nibWithCellClass: TrendingRepositoryShimmerTableViewCell.self)
        tableView.register(nibWithCellClass: TrendingRepositoryTableViewCell.self)
        
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44.0)
        let activityIndicatorView = UIActivityIndicatorView(frame: frame)
        activityIndicatorView.startAnimating()
        tableView.tableFooterView = activityIndicatorView
        
        retryAnimationView.contentMode = .scaleAspectFit
        retryAnimationView.loopMode = .loop
        retryAnimationView.animationSpeed = Const.lottieAnimationSpeed
        
        errorMessageLabel.text = "errorMessage".localized()
        
        errorDescriptionLabel.text = "errorDescription".localized()
        
        retryButton.setTitle("retry".localized(), for: .normal)
        retryButton.applyRoundedRectStyling()
    }
    
    @objc func refreshData() {
        viewModel.fetchRepositories()
    }
    
    func bindViewModel() {
        viewModel.changeHandler = { [weak self] change in
            guard let self = self else {
                return
            }
            self.applyChange(change)
        }
    }
    
    func applyChange(_ change: TrendingRepositoriesViewModel.Change) {
        switch change {
        case .error:
            refreshControl.endRefreshing()
            errorView.isHidden = false
            retryAnimationView.play()
            tableView.scrollToTop(animated: false)
        case .items(let items):
            refreshControl.endRefreshing()
            tableView.isScrollEnabled = true
            tableView.isUserInteractionEnabled = true
            if case .loading = presentationTypes.first {
                presentationTypes = items
            } else {
                presentationTypes.append(contentsOf: items)
            }
            tableView.reloadData()
        case .loading(let items):
            tableView.isScrollEnabled = false
            tableView.isUserInteractionEnabled = false
            errorView.isHidden = true
            presentationTypes = items
            retryAnimationView.pause()
            tableView.reloadData()
        case .paginationEnded:
            tableView.tableFooterView = nil
        case .selected(let item, let index):
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? TrendingRepositoryTableViewCell else {
                return
            }
            cell.toggleExpanded()
            presentationTypes[index] = item
            UIView.animate(withDuration: Const.animationDuration) {
                self.tableView.performBatchUpdates(nil)
            }
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
            let cell = tableView.dequeueReusableCell(withClass: TrendingRepositoryTableViewCell.self)
            cell.delegate = self
            cell.fill(presentation)
            return cell
        case .loading:
            return tableView.dequeueReusableCell(withClass: TrendingRepositoryShimmerTableViewCell.self)
        }
    }
}

// MARK: - UITableViewDelegate

extension TrendingRepositoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRepositoryAt(indexPath.row)
    }
    
    func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath
    ) {
        guard indexPath.row == presentationTypes.count - 1 else {
            return
        }
        viewModel.fetchNextPage()
    }
}

// MARK: TrendingRepositoryTableViewCellDelegate

extension TrendingRepositoriesViewController: TrendingRepositoryTableViewCellDelegate {
    
    func trendingRepositoryTableViewCellDidTapTitleButton(cell: TrendingRepositoryTableViewCell) {
        guard let row = tableView.indexPath(for: cell)?.row else {
            return
        }
        viewModel.openRepositoryDetailAt(row)
    }
    
    func trendingRepositoryTableViewCellDidTapInfoButton(cell: TrendingRepositoryTableViewCell) {
        guard let row = tableView.indexPath(for: cell)?.row else {
            return
        }
        viewModel.openHomepageAt(row)
    }
}
