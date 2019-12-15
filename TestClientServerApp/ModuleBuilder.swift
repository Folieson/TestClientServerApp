//
//  ModuleBuilder.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit

protocol Builder {
    static func createMain() -> UIViewController
    static func createDetail(itemId: Int) -> UIViewController
}

class ModuleBuilder: Builder {
    static func createMain() -> UIViewController {
        let view = MainViewController()
        let requestBuilder = RequestBuilder()
        let networkService = NetworkService(requestBuilder: requestBuilder)
        let presenter = MainPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    static func createDetail(itemId: Int) -> UIViewController {
        let view = DetailViewController()
        let requestBuilder = RequestBuilder()
        let networkService = NetworkService(requestBuilder: requestBuilder)
        let presenter = DetailPresenter(view: view, networkService: networkService, itemId: itemId)
        view.presenter = presenter
        return view
    }
}
