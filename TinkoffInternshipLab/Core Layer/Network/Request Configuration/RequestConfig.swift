//
//  RequestConfig.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: Parsable {
    let request: IRequest
    let parser: Parser
}
