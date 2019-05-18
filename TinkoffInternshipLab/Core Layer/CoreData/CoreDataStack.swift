//
//  CoreDataStack.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import CoreData

private extension String {
    static let modelName: String = "TinkoffNewsModel"
    static let coreDataExtension: String = "momd"
    static let storePathName: String = "TinkoffNews.sqlite"
}

protocol ICoreDataStack {
    var mainManagedObjectContext: NSManagedObjectContext { get set }
    var privateNewDataManagedObjectContext: NSManagedObjectContext { get set }
    var managedObjectModel: NSManagedObjectModel? { get set }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get set }
    func saveChanges(context: NSManagedObjectContext, errorHandler: @escaping (String) -> Void)
}

final class CoreDataStack: ICoreDataStack {
    /// Main Context
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.privateSaveManagedObjectContext
        managedObjectContext.mergePolicy = NSOverwriteMergePolicy
        return managedObjectContext
    }()
    
    /// Private Context which receives New Data
    lazy var privateNewDataManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = self.mainManagedObjectContext
        managedObjectContext.mergePolicy = NSOverwriteMergePolicy
        return managedObjectContext
    }()
    
    /// Private Context which saves data
    private lazy var privateSaveManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSOverwriteMergePolicy
        return managedObjectContext
    }()
    
    /// Managed Object Model
    lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: .modelName, withExtension: .coreDataExtension)
            else { print(loc("model_url_error")); return nil }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            else { print(loc("managed_object_model_error")); return nil }
        return managedObjectModel
    }()
    
    /// StoreURL for Persistent Store
    private var storeURL: URL {
        let documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectoryURL.appendingPathComponent(.storePathName)
        return url
    }
    
    /// Persistent Store Coordinator
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        } catch {
            print(loc("persistent_store_coordinator_error"))
        }
        return persistentStoreCoordinator
    }()
    
    /// Perform Saving
    func saveChanges(context: NSManagedObjectContext, errorHandler: @escaping (String) -> Void) {
        if context.hasChanges {
            context.perform { [weak self] in
                guard let self = self else { return }
                do {
                    try context.save()
                } catch let error {
                    errorHandler(error.localizedDescription)
                }
                if let parentContext = context.parent {
                    self.saveChanges(context: parentContext, errorHandler: errorHandler)
                }
            }
        } else {
            print(loc("context_no_changes"))
        }
    }
}

