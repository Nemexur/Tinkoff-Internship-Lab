//
//  TinkoffNewsPresenter.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

private extension Int {
    static let tinkoffAtriclesSize: Int = 20
}

struct TinkoffNewsModel {
    let id: String
    let newsLabel: String
    let newsDate: String
    var visitCounter: Int
    let urlSlug: String
    
    static func from(_ data: TinkoffArticle) -> TinkoffNewsModel {
        return TinkoffNewsModel(id: data.id ?? "",
                                newsLabel: data.title ?? "",
                                newsDate: data.updatedTime ?? "",
                                visitCounter: Int(data.visitCounter ?? "0") ?? 0,
                                urlSlug: data.urlSlug ?? "")
    }
}

protocol ITinkoffNewsPresenter {
    var viewModel: [TinkoffNewsModel] { get }
    /// Load Tinkoff News
    func loadTinkoffNews()
    /// Request Tinkoff News from Core Data
    func requestTinkoffNews()
    /// Update Visit Counter Badge
    func updateBadge(for article: TinkoffNewsModel, with index: Int)
}

protocol ITinkoffNewsView: class {
    /// Update Data Source of View
    func updateDataSource()
    /// Present Alert with Error
    func showErrorAlert(error: String)
}

final class TinkoffNewsPresenter: ITinkoffNewsPresenter {
    var viewModel: [TinkoffNewsModel] = []

    // Dependencies
    weak var view: ITinkoffNewsView?
    
    private let requestManager: IRequestManager
    private let coreDataManager: ICoreDataManager
    
    // MARK: Init
    
    init(requestManager: IRequestManager, coreDataManager: ICoreDataManager) {
        self.requestManager = requestManager
        self.coreDataManager = coreDataManager
    }
    
    // MARK: ITinkoffNewsPresenter
    
    func loadTinkoffNews() {
        let results: [TinkoffArticle] = coreDataManager.fetch()
        if !results.isEmpty {
            results.forEach { viewModel.append(TinkoffNewsModel.from($0)) }
            view?.updateDataSource()
        } else {
            requestTinkoffNews()
        }
    }
    
    func updateBadge(for article: TinkoffNewsModel, with index: Int) {
        let newCounter = article.visitCounter + 1
        viewModel[index].visitCounter = newCounter
        coreDataManager.updateTinkoffArticle(for: article.id, newDataType: .badge(newCounter)) { [weak self] error in
            self?.view?.showErrorAlert(error: error)
        }
    }
    
    func requestTinkoffNews() {
        requestManager.send(with: RequestFactory.tinkoffNewsConfig(pageSize: .tinkoffAtriclesSize)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                for article in articles.news {
                    if let result: TinkoffArticle = self.coreDataManager.fetch(with: article.id) {
                        self.viewModel.append(TinkoffNewsModel.from(result))
                    } else {
                        guard let newArticle = TinkoffArticle.build(in: self.coreDataManager.contextForNewData,
                                                                    id: article.id,
                                                                    title: article.title,
                                                                    updatedTime: article.updatedTime,
                                                                    text: nil,
                                                                    visitCounter: "0",
                                                                    urlSlug: article.slug)
                            else { self.view?.showErrorAlert(error: loc("api_result_error")); return }
                        self.viewModel.append(TinkoffNewsModel.from(newArticle))
                    }
                }
                self.view?.updateDataSource()
                self.coreDataManager.save(in: .newDataContext) { [weak self] error in
                    self?.view?.showErrorAlert(error: error)
                }
            case .error(let error):
                self.view?.showErrorAlert(error: error)
            }
        }
    }
}
