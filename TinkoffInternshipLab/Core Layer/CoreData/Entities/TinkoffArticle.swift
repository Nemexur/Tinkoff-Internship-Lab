//
//  TinkoffArticle.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 16/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import CoreData

extension TinkoffArticle {
    /// Insert New Tinkoff Article into Core Data
    static func insertArticle(into context: NSManagedObjectContext) -> TinkoffArticle? {
        guard let article = NSEntityDescription.insertNewObject(forEntityName: String(describing: TinkoffArticle.self),
                                                                into: context) as? TinkoffArticle
            else { return nil }
            return article
    }
    
    /// Build Tinkoff Article Object
    static func build(in context: NSManagedObjectContext,
                      id: String,
                      title: String,
                      updatedTime: String,
                      text: String?,
                      visitCounter: String,
                      urlSlug: String) -> TinkoffArticle? {
        let newArticle = TinkoffArticle.insertArticle(into: context)
        newArticle?.id = id
        newArticle?.title = title
        newArticle?.urlSlug = urlSlug
        newArticle?.visitCounter = visitCounter
        newArticle?.updatedTime = updatedTime
        return newArticle
    }
}
