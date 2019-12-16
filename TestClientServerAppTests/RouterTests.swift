//
//  RouterTests.swift
//  TestClientServerAppTests
//
//  Created by Андрей Понамарчук on 16.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import XCTest
@testable import TestClientServerApp

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTests: XCTestCase {
    var router: RouterProtocol!
    var navigationController: MockNavigationController!
    var assemblyBuilder: AssemblyBuilderProtocol!

    override func setUp() {
        navigationController = MockNavigationController()
        assemblyBuilder = AssemblyModuleBuilder()
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
    }

    override func tearDown() {
        navigationController = nil
        assemblyBuilder = nil
        router = nil
    }

    func testShowDetail() {
        router.showDetail(itemId: 1)
        let detailVC = navigationController.presentedVC
        XCTAssertTrue(detailVC is DetailViewController)
    }
    
    func testInitialViewController() {
        router.initialViewController()
        XCTAssertTrue(navigationController.viewControllers.count == 1)
        XCTAssertTrue(navigationController.viewControllers[0] is MainViewController)
    }
    func testPopToRoot() {
        router.initialViewController()
        router.showDetail(itemId: 1)
        router.popToRoot()
        print(navigationController.viewControllers.count)
        XCTAssertTrue(navigationController.viewControllers.count == 1)
        XCTAssertTrue(navigationController.viewControllers[0] is MainViewController)
    }
}
