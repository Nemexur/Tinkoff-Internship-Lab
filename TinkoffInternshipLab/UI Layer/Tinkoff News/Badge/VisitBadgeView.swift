//
//  VisitBadgeView.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import UIKit

final class VisitBadgeView: UIView {
    // UI
    @IBOutlet private weak var badge: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.loadNib()
        self.makeRounded()
    }
    
    func setup(with counter: Int) {
        badge.text = "\(counter)"
    }
}
