//
//  APIInformation.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

struct APIInformation {
    enum ForPixabayImages {
        static func newTinkoffNewsRequest(pageSize: Int, pageOffset: Int) -> IRequest {
            let urlString = "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticles?pageSize=\(pageSize)&pageOffset=\(pageOffset)"
            guard let url = URL(string: urlString) else { return Request(urlRequest: nil) }
            return Request(urlRequest: URLRequest(url: url))
        }
        
        static func tinkoffNewsDetails(urlSlug: String) -> IRequest {
            let urlString = "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticle?urlSlug=\(urlSlug)"
            guard let url = URL(string: urlString) else { return Request(urlRequest: nil) }
            return Request(urlRequest: URLRequest(url: url))
        }
    }
}
