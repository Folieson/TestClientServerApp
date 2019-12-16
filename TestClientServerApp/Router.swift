//
//  Router.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 16.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(itemId: Int?)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMain(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showDetail(itemId: Int?) {
        if let navigationController = navigationController, let itemId = itemId {
            guard let detailViewController = assemblyBuilder?.createDetail(itemId: itemId, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func popToRoot() {
        print("popToRoot")
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
