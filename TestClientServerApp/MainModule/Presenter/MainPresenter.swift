//
//  MainPresenter.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
    func success()
    func failure(error: Error)
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol MainPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    var items: [Item] { get set }
    func getItemsPage(pageNumb: Int)
    func tapOnTheItem(itemId: Int?)
}

class MainPresenter: MainPresenterProtocol {
    private weak var view: MainViewProtocol?
    private var router: RouterProtocol
    private let networkService: NetworkServiceProtocol!
    var items: [Item] = [Item]()
    var lastPage = false
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func getItemsPage(pageNumb: Int) {
        let lastPageError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Last page"])
        if lastPage {
            self.view?.failure(error: lastPageError)
            return
        }
        self.view?.showActivityIndicator()
        networkService.getItemsPage(pageNumb: pageNumb) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.hideActivityIndicator()
                switch result {
                case .success(let itemsPage):
                    guard let itemsPage = itemsPage, let items = itemsPage.items, !items.isEmpty else {
                        self.lastPage = true
                        self.view?.failure(error: lastPageError)
                        return
                    }
                    self.items.append(contentsOf: items)
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    func tapOnTheItem(itemId: Int?) {
        router.showDetail(itemId: itemId)
    }
}
