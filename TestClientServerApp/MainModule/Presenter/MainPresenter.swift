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
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol)
    var items: [Item] { get set }
    func getItemsPage(pageNumb: Int)
}

class MainPresenter: MainPresenterProtocol {
    private weak var view: MainViewProtocol?
    private let networkService: NetworkServiceProtocol!
    var items: [Item] = [Item]()
    private var lastPage = false
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    func getItemsPage(pageNumb: Int) {
        if lastPage { return }
        self.view?.showActivityIndicator()
        networkService.getItemsPage(pageNumb: pageNumb) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.hideActivityIndicator()
                switch result {
                case .success(let itemsPage):
                    guard let itemsPage = itemsPage, let items = itemsPage.items, !items.isEmpty else {
                        self.lastPage = true
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
}
