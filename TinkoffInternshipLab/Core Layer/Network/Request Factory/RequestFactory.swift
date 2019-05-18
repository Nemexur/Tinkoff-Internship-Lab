//
//  RequestFactory.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

struct RequestFactory {
    static func tinkoffNewsConfig(pageSize: Int = 100, pageOffset: Int = 0) -> RequestConfig<TinkoffNewsJSONParser> {
        return RequestConfig<TinkoffNewsJSONParser>(request: APIInformation.ForPixabayImages.newTinkoffNewsRequest(pageSize: pageSize,
                                                                                                                   pageOffset: pageOffset),
                                                    parser: TinkoffNewsJSONParser())
    }
    
    static func tinkoffArticleConfig(urlSlug: String) -> RequestConfig<TinkoffArticleJSONParser> {
        return RequestConfig<TinkoffArticleJSONParser>(request: APIInformation.ForPixabayImages.tinkoffNewsDetails(urlSlug: urlSlug),
                                                    parser: TinkoffArticleJSONParser())
    }
}
