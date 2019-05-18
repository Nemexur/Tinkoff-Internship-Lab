//
//  TinkoffNewsViewController.swift
//  TinkoffInternshipLab
//
//  Created by Alex Milogradsky on 15/05/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import UIKit

final class TinkoffNewsViewController: UIViewController {
    // UI
    @IBOutlet private weak var tableView: UITableView!
    
    // Dependencies
    private let refreshControl = UIRefreshControl()
    private var loader: LoadingView?
    
    private let presenter: ITinkoffNewsPresenter
    private let serviceAssembly: IServiceAssembly
    
    // MARK: Init
    
    init(serviceAssembly: IServiceAssembly) {
        let presenter = TinkoffNewsPresenter(requestManager: serviceAssembly.requestManager, coreDataManager: serviceAssembly.coreDataManager)
        self.presenter = presenter
        self.serviceAssembly = serviceAssembly
        super.init(nibName: String(describing: TinkoffNewsViewController.self), bundle: nil)
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
        presenter.loadTinkoffNews()
    }
    
    // Setup
    private func setup() {
        title = loc("tinkoff_news_title")
        loader = setupLoader()
        setupTableView()
        setupPullToRefresh()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: String(describing: TinkoffNewsTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: TinkoffNewsTableViewCell.self))
        tableView.refreshControl = refreshControl
        tableView.isHidden = true
    }
    
    private func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(updateTinkoffNews), for: .valueChanged)
    }
    
    @objc private func updateTinkoffNews() {
        if !CheckInternet.connection {
            DispatchQueue.main.asyncAfter(deadline: .now() + .interval300ms) { [weak self] in
                guard let self = self else { return }
                self.showAlert(text: loc("no_internet_conection"))
                self.refreshControl.endRefreshing()
            }
        } else {
            presenter.requestTinkoffNews()
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension TinkoffNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TinkoffNewsTableViewCell.self),
                                                       for: indexPath) as? TinkoffNewsTableViewCell
            else { return UITableViewCell() }
        let tinkoffNews = presenter.viewModel[indexPath.row]
        cell.setup(with: tinkoffNews)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = presenter.viewModel[indexPath.row]
        defer { presenter.updateBadge(for: article, with: indexPath.row); updateCell(for: indexPath) }
        let view = TinkoffArticleViewController(serviceAssembly: serviceAssembly,
                                                urlSlug: article.urlSlug,
                                                id: article.id)
        navigationController?.pushViewController(view, animated: true)
    }
    
    private func updateCell(for indexPath: IndexPath){
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

// MARK: - ITinkoffNewsView

extension TinkoffNewsViewController: ITinkoffNewsView {
    func updateDataSource() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .interval300ms) { [weak self] in
            guard let self = self else { return }
            self.finishUpdating()
            self.tableView.reloadData()
        }
    }
    
    func showErrorAlert(error: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.finishUpdating()
            self.showAlert(text: error)
        }
    }
    
    private func finishUpdating() {
        if loader?.isAnimating == true { loader?.stopAnimation() }
        if tableView.isHidden == true {
            UIView.animate(withDuration: .interval300ms) {
                self.tableView.isHidden = false
            }
        }
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}
