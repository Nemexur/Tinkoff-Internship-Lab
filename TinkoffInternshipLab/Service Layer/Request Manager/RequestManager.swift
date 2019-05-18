//
//  RequestManager.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

protocol IRequestManager {
    var requestSender: IRequestSender { get set }
    /// Send Request With Configuration
    func send<Parser>(with config: RequestConfig<Parser>,
                      completion: @escaping (Result<Parser.Model>) -> Void)
}

final class RequestManager: IRequestManager {
    var requestSender: IRequestSender
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    func send<Parser>(with config: RequestConfig<Parser>,
                      completion: @escaping (Result<Parser.Model>) -> Void) {
        requestSender.send(config: config, completion: completion)
    }
}
