//
//  AlertView.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

private extension CGFloat {
    static let yAxisMargin: CGFloat = 32
    static let widthMargin: CGFloat = 24
    static let xAxisMargin: CGFloat = 12
    static let shadowHeight: CGFloat = 4
}

final class AlertView: UIView {
    /// Message Type
    enum MessageType {
        case error
        case normal
        
        var color: UIColor {
            switch self {
            case .error:
                return .red
            case .normal:
                return .green
            }
        }
    }
    
    // UI
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    
    private static var sharedView: AlertView!
    
    private static func loadAlertView() -> AlertView? {
        let nib = UINib(nibName: String(describing: AlertView.self), bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? AlertView else { return nil }
        return view
    }
    
    /// Show Alert in ViewController
    static func show(in viewController: UIViewController, text: String, textType: AlertView.MessageType) {
        if sharedView == nil {
            guard let view = loadAlertView() else { return }
            sharedView = view
        }
        
        setup()
        sharedView.textLabel.text = text
        sharedView.backgroundColor = textType.color
        
        if sharedView.superview == nil {
            let y = viewController.view.frame.height - sharedView.frame.size.height - .yAxisMargin
            sharedView.frame = CGRect(x: .xAxisMargin,
                                      y: y,
                                      width: viewController.view.frame.size.width - .widthMargin,
                                      height: sharedView.frame.size.height)
            sharedView.alpha = 0
            viewController.view.addSubview(sharedView)
            sharedView.fadeIn()
            DispatchQueue.main.asyncAfter(deadline: .now() + .interval2s) {
                sharedView.perform(#selector(fadeOut), with: nil)
            }
        }
    }
    
    private static func setup() {
        sharedView.layer.masksToBounds = false
        sharedView.layer.shadowColor = UIColor.darkGray.cgColor
        sharedView.layer.shadowOpacity = 1
        sharedView.layer.shadowOffset = CGSize(width: 0, height: .shadowHeight)
        sharedView.closeButton.tintColor = .white
    }
    
    @IBAction private func closePressed(_ sender: UIButton) {
        fadeOut()
    }

    private func fadeIn() {
        UIView.animate(withDuration: .interval300ms) {
            self.alpha = 1
        }
    }
    
    @objc private func fadeOut() {
        UIView.animate(withDuration: .interval300ms, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
