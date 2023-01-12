//
//  UITableView+NibRegistering.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 12.01.2023.
//

import UIKit

extension UITableView {
    
    func registerNibReusableCell<T: UITableViewCell>(_ type: T.Type) {
        let description = String(describing: type)
        let nib = UINib(nibName: description, bundle: Bundle(for: type))
        register(nib, forCellReuseIdentifier: description)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(
        _ indexPath: IndexPath, type: T.Type = T.self
    ) -> T {
        let description = String(describing: type)
        if let cell = dequeueReusableCell(withIdentifier: description, for: indexPath) as? T {
            return cell
        }
        fatalError(
            "Failed to dequeue a cell with identifier \(description) matching type \(type.self). "
            + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
            + "and that you registered the cell beforehand"
        )
    }
}
