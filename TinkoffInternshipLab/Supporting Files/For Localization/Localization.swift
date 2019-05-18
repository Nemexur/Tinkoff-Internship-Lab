//
//  Localization.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 18/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

typealias LocalizedString = String

func loc(_ string: String) -> LocalizedString {
    return NSLocalizedString(string, comment: "")
}
