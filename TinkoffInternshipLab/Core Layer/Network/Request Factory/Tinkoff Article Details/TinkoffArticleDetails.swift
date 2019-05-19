//
//  TinkoffArticleDetails.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 16/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

struct TinkoffArticleDetails: Codable {
    let id: String
    let title: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case response
        case id
        case title
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        id = try response.decode(String.self, forKey: .id)
        title = try response.decode(String.self, forKey: .title)
        text = try response.decode(String.self, forKey: .text)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        try response.encode(id, forKey: .id)
        try response.encode(title, forKey: .title)
        try response.encode(text, forKey: .text)
    }
}

final class TinkoffArticleJSONParser: Parsable {
    typealias Model = TinkoffArticleDetails
    func parse(data: Data) -> Model? {
        let jsonDecoder = JSONDecoder()
        do {
            let tinkoffArticleModel = try jsonDecoder.decode(Model.self, from: data)
            return tinkoffArticleModel
        } catch {
            return nil
        }
    }
}
