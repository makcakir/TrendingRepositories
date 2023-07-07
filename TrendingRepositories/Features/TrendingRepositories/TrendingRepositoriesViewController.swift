//
//  TrendingRepositoriesViewController.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Lottie
import SwifterSwift
import UIKit

// swiftlint:disable:next line_length
final class TrendingRepositoriesViewController: ViewController<TrendingRepositoriesDependency, TrendingRepositoriesViewModel> {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var retryAnimationView: LottieAnimationView!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var errorDescriptionLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    private let refreshControl = UIRefreshControl()

    private var presentationTypes: [TrendingRepositoriesViewModel.PresentationType] = []
    private var headerTitle: String?
    private var filters: [String]?
    private var selectedFilterIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        bindViewModel()
        refreshData()
    }

    @IBAction private func retryButtonTapped(_ sender: Any) {
        refreshData()
    }
}

// MARK: - Helpers

private extension TrendingRepositoriesViewController {

    enum Const {
        static let animationDuration: CGFloat = 0.3
        static let lottieAnimationSpeed: CGFloat = 0.5
        static let activityIndicatorHeight: CGFloat = 44
    }

    func setupSubviews() {
        title = R.string.localizable.trendingRepositories()

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableView.register(nibWithCellClass: TrendingRepositoryShimmerTableViewCell.self)
        tableView.register(nibWithCellClass: TrendingRepositoryTableViewCell.self)

        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: Const.activityIndicatorHeight)
        let activityIndicatorView = UIActivityIndicatorView(frame: frame)
        activityIndicatorView.startAnimating()
        tableView.tableFooterView = activityIndicatorView

        retryAnimationView.contentMode = .scaleAspectFit
        retryAnimationView.loopMode = .loop
        retryAnimationView.animationSpeed = Const.lottieAnimationSpeed

        errorMessageLabel.text = R.string.localizable.errorMessage()

        errorDescriptionLabel.text = R.string.localizable.errorDescription()

        retryButton.setTitle(R.string.localizable.retry(), for: .normal)
        retryButton.applyRoundedRectStyling()
    }

    @objc
    func refreshData() {
        refreshControl.endRefreshing()
        viewModel.fetchRepositories()
    }

    @objc
    func searchBarButtonItemTapped(barButtonItem: UIBarButtonItem) {
        showAlert(
            preferredStyle: .actionSheet, buttonTitles: filters, highlightedButtonIndex: selectedFilterIndex,
            barButtonItem: barButtonItem
        ) { index in
            self.viewModel.selectFilterAt(index)
        }
    }

    func bindViewModel() {
        viewModel.changeHandler = { [weak self] change in
            guard let self else {
                return
            }
            self.applyChange(change)
        }
    }

    func applyChange(_ change: TrendingRepositoriesViewModel.Change) {
        switch change {
        case .error:
            errorView.isHidden = false
            retryAnimationView.play()
            tableView.scrollToTop(animated: false)
        case .hideSearch:
            navigationItem.rightBarButtonItem = nil
        case let .items(items, resultMessage):
            tableView.isScrollEnabled = true
            tableView.isUserInteractionEnabled = true
            if case .loading = presentationTypes.first {
                presentationTypes = items
                headerTitle = resultMessage
            } else {
                presentationTypes.append(contentsOf: items)
            }
            tableView.reloadData()
        case .loading(let items):
            headerTitle = R.string.localizable.loading()
            tableView.scrollToTop(animated: false)
            tableView.isScrollEnabled = false
            tableView.isUserInteractionEnabled = false
            errorView.isHidden = true
            presentationTypes = items
            retryAnimationView.pause()
            tableView.reloadData()
        case .paginationEnded:
            tableView.tableFooterView = nil
        case let .selected(item, index):
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? TrendingRepositoryTableViewCell else {
                return
            }
            cell.toggleExpanded()
            presentationTypes[index] = item
            UIView.animate(withDuration: Const.animationDuration) {
                self.tableView.performBatchUpdates(nil)
            }
        case let .showSearch(filters, selectedFilterIndex):
            self.filters = filters
            self.selectedFilterIndex = selectedFilterIndex
            let barButtonItem = UIBarButtonItem(
                barButtonSystemItem: .search, target: self, action: #selector(searchBarButtonItemTapped(barButtonItem:))
            )
            navigationItem.rightBarButtonItem = barButtonItem
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle
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
