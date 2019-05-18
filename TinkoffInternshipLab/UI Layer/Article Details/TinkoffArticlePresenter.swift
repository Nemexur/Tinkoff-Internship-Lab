//
//  TinkoffArticelAssembly.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 16/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

struct TinkoffArticleModel {
    let title: String
    let text: String
    
    static func from(_ data: TinkoffArticle) -> TinkoffArticleModel {
        return TinkoffArticleModel(title: data.title ?? "", text: data.text ?? "")
    }
}
protocol ITinkoffArticlePresenter {
    var viewModel: TinkoffArticleModel { get }
    /// Load Data For Article
    func loadTinkoffArticle()
}

protocol ITinkoffArticleView: class {
    /// Update Page with New Information
    func updatePage()
    /// Present Alert with Error
    func showErrorAlert(error: String)
}

final class TinkoffArticlePresenter: ITinkoffArticlePresenter {
    // Dependencies
    weak var view: ITinkoffArticleView?
    
    var viewModel: TinkoffArticleModel = TinkoffArticleModel(title: "", text: "") {
        didSet {
            view?.updatePage()
        }
    }
    
    private let requestManager: IRequestManager
    private let urlSlug: String
    private let id: String
    private let coreDataManager: ICoreDataManager
    
    init(requestManager: IRequestManager, coreDataManager: ICoreDataManager, urlSlug: String, id: String) {
        self.requestManager = requestManager
        self.coreDataManager = coreDataManager
        self.urlSlug = urlSlug
        self.id = id
    }
    
    func loadTinkoffArticle() {
        if let result: TinkoffArticle = coreDataManager.fetch(with: id),
            result.text?.isEmpty == false {
            viewModel = TinkoffArticleModel.from(result)
        } else {
            loadFromAPI()
        }
    }
    
    private func loadFromAPI() {
        requestManager.send(with: RequestFactory.tinkoffArticleConfig(urlSlug: urlSlug)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let article: TinkoffArticle = self.coreDataManager.fetch(with: model.id)
                    else { self.view?.showErrorAlert(error: loc("api_result_error")); return }
                self.coreDataManager.updateTinkoffArticle(for: model.id, newDataType: .text(model.text)) { [weak self] error in
                    self?.view?.showErrorAlert(error: error)
                }
                self.viewModel = TinkoffArticleModel.from(article)
            case .error(let error):
                self.view?.showErrorAlert(error: error)
            }
        }
    }
}

