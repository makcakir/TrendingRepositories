//
//  TrendingRepositoriesViewController.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import UIKit

class TrendingRepositoriesViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
}

private extension TrendingRepositoriesViewController {
    
    func setupSubviews() {
        title = "trending".localized()
    }
}
