//
//  UIViewController+ActionSheet.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 16.03.2023.
//

import UIKit

extension UIViewController {

    @discardableResult
    func showAlert(
        title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style,
        buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil,
        barButtonItem: UIBarButtonItem?, completion: ((Int) -> Void)? = nil
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: title, message: message, preferredStyle: preferredStyle
        )
        for (index, buttonTitle) in (buttonTitles ?? []).enumerated() {
            let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
                completion?(index)
            }
            alertController.addAction(action)
            if let highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
                action.setValue(true, forKey: "checked")
            }
        }
        let style: UIAlertAction.Style = preferredStyle == .actionSheet ? .cancel : .destructive
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: style, handler: nil))
        alertController.popoverPresentationController?.barButtonItem = barButtonItem
        present(alertController, animated: true, completion: nil)
        return alertController
    }
}
