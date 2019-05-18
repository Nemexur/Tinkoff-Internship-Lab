//
//  Request.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

protocol IRequest {
    /// URL Request
    var urlRequest: URLRequest? { get }
}

final class Request: IRequest {
    var urlRequest: URLRequest?
    init(urlRequest: URLRequest?) {
        self.urlRequest = urlRequest
    }
}
