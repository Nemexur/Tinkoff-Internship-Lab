//
//  APIInformation.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

struct APIInformation {
    enum Tinkoff {
        static func newTinkoffNewsRequest(pageSize: Int, pageOffset: Int) -> IBaseRequest {
            let urlString = "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticles?pageSize=\(pageSize)&pageOffset=\(pageOffset)"
            guard let url = URL(string: urlString) else { return BaseRequest(urlRequest: nil) }
            return BaseRequest(urlRequest: URLRequest(url: url))
        }
        
        static func tinkoffNewsDetails(urlSlug: String) -> IBaseRequest {
            let urlString = "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticle?urlSlug=\(urlSlug)"
            guard let url = URL(string: urlString) else { return BaseRequest(urlRequest: nil) }
            return BaseRequest(urlRequest: URLRequest(url: url))
        }
    }
}
