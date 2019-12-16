//
//  DetailPresenter.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 15.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import Foundation

protocol DetailViewProtocol: class {
    func setItemDetails()
    func setSimilarItems()
    func failure(error: Error)
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol DetailPresenterProtocol: class {
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, itemId: Int)
    var itemDetails: ItemDatails? { get set }
    var itemImageData: Data? { get set }
    var similarItems: [SimilarItem]? { get set }
    func getItemDetails()
    func getSimilarItems()
    func tapOnTheSimilarItem(itemId: Int?)
    func tapOnTheReturnToTheMainScreen()
    func formatDateFromISO8601(date: String?) -> String?
}

class DetailPresenter: DetailPresenterProtocol {
    private weak var view: DetailViewProtocol?
    private let networkService: NetworkServiceProtocol!
    private let router: RouterProtocol
    private let itemId: Int
    var itemDetails: ItemDatails?
    var itemImageData: Data?
    var similarItems: [SimilarItem]?
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, itemId: Int) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.itemId = itemId
        self.getItemDetails()
    }
    
    func getItemDetails() {
        self.view?.showActivityIndicator()
        networkService.getItemDetails(itemId: itemId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.hideActivityIndicator()
                switch result {
                case .success(let itemDetails):
                    self.itemDetails = itemDetails
                    self.getImageData(urlString: itemDetails?.imageURL)
                    self.view?.setItemDetails()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func getSimilarItems() {
        self.view?.showActivityIndicator()
        networkService.getSimilarItems(itemId: itemId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.hideActivityIndicator()
                switch result {
                case .success(let similarItems):
                    self.similarItems = similarItems
                    self.view?.setSimilarItems()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func tapOnTheSimilarItem(itemId: Int?) {
        router.showDetail(itemId: itemId)
    }
    
    func tapOnTheReturnToTheMainScreen() {
        router.popToRoot()
    }
    
    func formatDateFromISO8601(date: String?) -> String? {
        guard let dateStr = date else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateStr) else { return nil}
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        outputDateFormatter.dateFormat = "d MMM yyyy"
        return outputDateFormatter.string(from: date)
    }
    
    func getImageData(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        if let data = try? Data(contentsOf: url) {
            self.itemImageData = data
        }
    }
}
