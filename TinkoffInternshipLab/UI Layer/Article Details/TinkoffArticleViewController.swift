//
//  TinkoffArticleViewController.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 16/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import UIKit

private extension UIEdgeInsets {
    static let textViewInsets: UIEdgeInsets = UIEdgeInsets(top: 0,
                                                           left: 10,
                                                           bottom: 0,
                                                           right: 10)
}

final class TinkoffArticleViewController: UIViewController {
    // UI
    @IBOutlet private weak var articleTitle: UILabel!
    @IBOutlet private weak var articleText: UITextView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // Dependencies
    private var loader: LoadingView?
    
    private let serviceAssembly: IServiceAssembly
    private let presenter: ITinkoffArticlePresenter
    
    // MARK: Init
    
    init(serviceAssembly: IServiceAssembly, urlSlug: String, id: String) {
        self.serviceAssembly = serviceAssembly
        let presenter = TinkoffArticlePresenter(requestManager: self.serviceAssembly.requestManager,
                                                coreDataManager: self.serviceAssembly.coreDataManager,
                                                urlSlug: urlSlug,
                                                id: id)
        self.presenter = presenter
        super.init(nibName: String(describing: TinkoffArticleViewController.self), bundle: nil)
        presenter.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loader?.startAnimation()
        presenter.loadTinkoffArticle()
    }

    private func setup() {
        title = loc("tinkoff_article_title")
        scrollView.isHidden = true
        articleText.textContainerInset = .textViewInsets
        loader = setupLoader()
    }
}

// MARK: ITinkoffArticleView

extension TinkoffArticleViewController: ITinkoffArticleView {
    func updatePage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .interval300ms) { [weak self] in
            guard let self = self else { return }
            self.articleTitle.text = self.presenter.viewModel.title
            self.articleText.text = self.presenter.viewModel.text
            /*
            По какой-то причине скролл вью не показывает текст, если он занимает где-то более 10000 высоты
            Чтобы это исправить просто включим и выключим скролл
            */
            self.articleText.isScrollEnabled = true
            self.articleText.isScrollEnabled = false
            self.loader?.stopAnimation()
            if self.scrollView.isHidden {
                UIView.animate(withDuration: .interval300ms) {
                    self.scrollView.isHidden = false
                }
            }
        }
    }
    
    func showErrorAlert(error: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showAlert(text: error)
            self.loader?.stopAnimation()
        }
    }
}
