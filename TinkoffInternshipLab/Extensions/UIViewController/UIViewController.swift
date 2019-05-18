//
//  UIViewController.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

private extension CGFloat {
    static let loaderHeight: CGFloat = 40
}

extension UIViewController {
    /// Show Alert in ViewController
    func showAlert(text: String, alertType: AlertView.MessageType = .error) {
        AlertView.show(in: self, text: text, textType: alertType)
    }
    
    /// Add and Setup Loader
    func setupLoader() -> LoadingView {
        let loadingView = LoadingView(frame: CGRect(origin: view.center,
                                                    size: CGSize(width: .loaderHeight, height: .loaderHeight)))
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: .loaderHeight).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: .loaderHeight).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return loadingView
    }
}
