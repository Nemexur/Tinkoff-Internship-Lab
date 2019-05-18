//
//  RequestSender.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

protocol IRequestSender {
    /// Send Request With Configuration
    func send<Parser>(config: RequestConfig<Parser>, completion: @escaping (Result<Parser.Model>) -> Void)
}

final class RequestSender: IRequestSender {
    let session = URLSession.shared
    func send<Parser>(config: RequestConfig<Parser>, completion: @escaping (Result<Parser.Model>) -> Void) where Parser : Parsable {
        guard let urlRequest = config.request.urlRequest else {
            completion(.error(loc("url_request_error")))
            return
        }
        let task = session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.error("\(error.localizedDescription)"))
                return
            }
            guard let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completion(.error(loc("model_parsing_error")))
                    return
            }
            completion(.success(parsedModel))
        }
        task.resume()
    }
}
