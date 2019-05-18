//
//  PresentationAssembly.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {
    /// Setup Tinkoff News View to Present
    func setupTinkoffNewsView() -> TinkoffNewsViewController
}

final class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServiceAssembly
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    func setupTinkoffNewsView() -> TinkoffNewsViewController {
        return TinkoffNewsViewController(serviceAssembly: serviceAssembly)
    }
}
