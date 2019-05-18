//
//  Parser.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

protocol Parsable {
    associatedtype Model
    /// Parse Data To Model
    func parse(data: Data) -> Model?
}
