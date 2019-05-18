//
//  ServiceAssembly.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
    var requestManager: IRequestManager { get }
    var coreDataManager: ICoreDataManager { get }
}

final class ServiceAssembly: IServiceAssembly {
    private let coreAssembly: ICoreAssembly
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    lazy var requestManager: IRequestManager = RequestManager(requestSender: coreAssembly.requestSender)
    lazy var coreDataManager: ICoreDataManager = CoreDataManager(coreDataStack: coreAssembly.coreDataStack)
}
