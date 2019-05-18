//
//  UIColor.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// RGBA init UIColor
    convenience init(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat) {
        self.init(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: A)
    }
    /// RGB init UIColor
    convenience init(R: CGFloat, G: CGFloat, B: CGFloat) {
        self.init(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: 1.0)
    }
}
