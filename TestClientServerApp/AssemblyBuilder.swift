//
//  AssemblyBuilder.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMain(router: RouterProtocol) -> UIViewController
    func createDetail(itemId: Int, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createMain(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let requestBuilder = RequestBuilder()
        let networkService = NetworkService(requestBuilder: requestBuilder)
        let presenter = MainPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetail(itemId: Int, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let requestBuilder = RequestBuilder()
        let networkService = NetworkService(requestBuilder: requestBuilder)
        let presenter = DetailPresenter(view: view, networkService: networkService, router: router, itemId: itemId)
        view.presenter = presenter
        return view
    }
}
