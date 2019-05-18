//
//  UIView.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// Round Corners of UIView
    func makeRounded() {
        let shape = CAShapeLayer()
        let radius = floor(self.bounds.height / 2)
        shape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = shape
        self.layer.masksToBounds = true
    }
    
    /// Load UIView from Nib
    func loadNib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
            else { return }
        view.frame = bounds
        addSubview(view)
    }
}
