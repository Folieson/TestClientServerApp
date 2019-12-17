//
//  DetailPresenter.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 15.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import Foundation
import CoreData

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
    private var context: NSManagedObjectContext?
    var itemDetails: ItemDatails?
    var itemImageData: Data?
    var similarItems: [SimilarItem]?
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, itemId: Int) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.itemId = itemId
        initContext()
        self.getItemDetails()
    }
    
    func getItemDetails() {
        self.view?.showActivityIndicator()
        context!.perform {
            do {
                let coreDataRequest: NSFetchRequest<ComputerCoreData> = ComputerCoreData.fetchRequest()
                coreDataRequest.predicate = NSPredicate(format: "id = %i", self.itemId)
                var computer = try coreDataRequest.execute().first
                if computer == nil {
                    self.networkService.getItemDetails(itemId: self.itemId) { [weak self] result in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            self.view?.hideActivityIndicator()
                            switch result {
                            case .success(let itemDetails):
                                let entity = NSEntityDescription.entity(forEntityName: "Computer", in: self.context!)
                                computer = ComputerCoreData(entity: entity!, insertInto: self.context!)
                                do {
                                    try self.saveItemDetailsToCoreData(itemDetails: itemDetails, computer: computer!)
                                } catch {
                                    print("can't save to core data")
                                }
                                self.itemDetails = itemDetails
                                self.getImageData(urlString: itemDetails?.imageUrl)
                                self.view?.setItemDetails()
                            case .failure(let error):
                                self.view?.failure(error: error)
                            }
                        }
                    }
                } else {
                    self.getItemDetailsFromCoreDataObject(computer: computer)
                    self.getImageData(urlString: self.itemDetails?.imageUrl)
                    self.view?.setItemDetails()
                }
            }
            catch {
                print("can't get itemDetails with id \(self.itemId)")
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
    
    func initContext() {
        self.context = AppDelegate.shared().persistentContainer.viewContext
    }
    
    func saveItemDetailsToCoreData(itemDetails: ItemDatails?, computer: ComputerCoreData) throws {
        guard let itemDetails = itemDetails, let computerId = itemDetails.id else { return }
        computer.computerDescription = itemDetails.description
        computer.id = Int16(computerId)
        computer.imageUrl = itemDetails.imageUrl
        computer.introduced = itemDetails.introduced
        computer.discounted = itemDetails.discounted
        guard let itemCompany = itemDetails.company, let companyId = itemCompany.id else { return }
        let entity = NSEntityDescription.entity(forEntityName: "Company", in: self.context!)
        let company = CompanyCoreData(entity: entity!, insertInto: self.context!)
        company.id = Int16(companyId)
        company.name = itemCompany.name
        computer.company = company
        self.context!.insert(computer)
        self.context!.insert(company)
        try context!.save()
    }
    
    func getItemDetailsFromCoreDataObject(computer: ComputerCoreData?) {
        var company: Company?
        if let companyCoreData = computer?.company {
            company = Company(id: Int(companyCoreData.id!), name: companyCoreData.name)
        }
        self.itemDetails = ItemDatails(id: Int(computer!.id!), name: computer?.name, introduced: computer?.introduced, discounted: computer?.discounted, imageUrl: computer?.imageUrl, company: company, description: computer?.computerDescription)
    }
}
