//
//  TinkoffNewsTableViewCell.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import UIKit

final class TinkoffNewsTableViewCell: UITableViewCell {
    // UI
    @IBOutlet private weak var newsLabel: UILabel!
    @IBOutlet private weak var newsDate: UILabel!
    @IBOutlet private weak var visitCounter: VisitBadgeView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(with model: TinkoffNewsModel) {
        selectionStyle = .none
        newsLabel.text = model.newsLabel
        newsDate.text = model.newsDate
        visitCounter.setup(with: model.visitCounter)
    }
}
