//
//  CoreDataManager.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 16/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import CoreData

enum ContextType {
    case mainContext
    case newDataContext
}

enum NewTinkoffArticleData {
    case text(String)
    case badge(Int)
}

protocol ICoreDataManager {
    var coreDataStack: ICoreDataStack { get }
    var contextForNewData: NSManagedObjectContext { get }
    /// Save New Data
    func save(in contextType: ContextType, errorHandler: @escaping (String) -> Void)
    /// Update Data of an Article
    func updateTinkoffArticle(for id: String, newDataType: NewTinkoffArticleData, errorHandler: @escaping (String) -> Void)
    /// Fetch All Objects of Certain Type from Core Data
    func fetch<T: NSManagedObject>() -> [T]
    /// Fetch Object with Certain Id
    func fetch<T: NSManagedObject>(with id: String) -> T?
}

final class CoreDataManager: ICoreDataManager {
    // Dependencies
    var coreDataStack: ICoreDataStack
    var contextForNewData: NSManagedObjectContext
    private let mainContext: NSManagedObjectContext
    private let coreDataModel: NSManagedObjectModel?
    
    // MARK: Init
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
        contextForNewData = self.coreDataStack.privateNewDataManagedObjectContext
        mainContext = self.coreDataStack.mainManagedObjectContext
        coreDataModel = contextForNewData.persistentStoreCoordinator?.managedObjectModel
    }

    // MARK: ICoreDataManager
    
    func save(in contextType: ContextType, errorHandler: @escaping (String) -> Void) {
        switch contextType {
        case .mainContext:
            coreDataStack.saveChanges(context: mainContext, errorHandler: errorHandler)
        case .newDataContext:
            coreDataStack.saveChanges(context: contextForNewData, errorHandler: errorHandler)
        }
    }

    func updateTinkoffArticle(for id: String, newDataType: NewTinkoffArticleData, errorHandler: @escaping (String) -> Void) {
        let article: TinkoffArticle? = fetch(with: id)
        switch newDataType {
        case .text(let text):
            article?.setValue(text, forKey: "text")
        case .badge(let visitCounter):
            article?.setValue("\(visitCounter)", forKey: "visitCounter")
        }
        save(in: .mainContext, errorHandler: errorHandler)
    }
    
    func fetch<T: NSManagedObject>() -> [T] {
        return getFetchRequestData(context: mainContext)
    }

    func fetch<T: NSManagedObject>(with id: String) -> T? {
        let fetchPredicate = NSPredicate(format: "id = %@", id)
        return getFetchRequestData(context: mainContext, predicate: fetchPredicate).first
    }
    
    /// Generic Method To Perform Fetch Request
    private func getFetchRequestData<T: NSManagedObject>(context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> [T] {
        if let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> {
            if predicate != nil { request.predicate = predicate }
            do {
                return try context.fetch(request)
            } catch { print(loc("fetching_data_error")); return [] }
        } else {
            return []
        }
    }
}
