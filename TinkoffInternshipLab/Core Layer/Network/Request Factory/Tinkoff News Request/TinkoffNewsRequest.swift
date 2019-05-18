//
//  TinkoffNewsRequest.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

struct TinkoffNewsJSONModel: Codable {
    let news: [NewsJSONModel]
    
    enum CodingKeys: String, CodingKey {
        case response
        case news
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        news = try response.decode([NewsJSONModel].self, forKey: .news)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        try response.encode(news, forKey: .news)
    }
}

struct NewsJSONModel: Codable {
    let id: String
    let title: String
    let updatedTime: String
    let slug: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case updatedTime
        case slug
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        let time = try container.decode(String.self, forKey: .updatedTime)
        let timeWithReplace = time.replacingOccurrences(of: "T", with: " ")
        updatedTime = timeWithReplace[0..<(timeWithReplace.count - 8)]
        slug = try container.decode(String.self, forKey: .slug)
    }
}

final class TinkoffNewsJSONParser: Parsable {
    typealias Model = TinkoffNewsJSONModel
    func parse(data: Data) -> Model? {
        let jsonDecoder = JSONDecoder()
        do {
            let pixabayModel = try jsonDecoder.decode(Model.self, from: data)
            return pixabayModel
        } catch {
            return nil
        }
    }
}
