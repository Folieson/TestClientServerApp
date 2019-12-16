//
//  MainModuleTest.swift
//  TestClientServerAppTests
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import XCTest
@testable import TestClientServerApp

class MockMainView: MainViewProtocol {
    var testSuccess: String?
    var testFailure: Error?
    var activityIndicator = UIActivityIndicatorView()
    var asyncSuccessExpectation: XCTestExpectation?
    var asyncHideExpectation: XCTestExpectation?
    var asyncFailExpectation: XCTestExpectation?
    var asyncLastPageExpectation: XCTestExpectation?
    
    func success() {
        self.testSuccess = "Success"
        asyncSuccessExpectation?.fulfill()
        asyncSuccessExpectation = nil
    }
    
    func failure(error: Error) {
        self.testFailure = error
        if error.localizedDescription == "Last page" {
            asyncLastPageExpectation?.fulfill()
            asyncLastPageExpectation = nil
        } else {
            asyncFailExpectation?.fulfill()
            asyncFailExpectation = nil
        }
        
    }
    
    func showActivityIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        asyncHideExpectation?.fulfill()
        asyncHideExpectation = nil
    }
}

class MockRouter: RouterProtocol {
    var itemId: Int?
    var popToRootOK: String?
    
    func initialViewController() {
        
    }
    
    func showDetail(itemId: Int?) {
        self.itemId = itemId
    }
    
    func popToRoot() {
        self.popToRootOK = ""
    }
    
    var navigationController: UINavigationController?
    
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    
}

class MockNetworkService: NetworkServiceProtocol {
    required init(requestBuilder: RequestBuilderProtocol) {
        
    }
    
    func getItemsPage(pageNumb: Int, completion: @escaping (ApiResult<ItemsPage?>) -> Void) {
        if pageNumb == 0 {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
        if pageNumb == 1 {
            completion(.success(nil))
        } 
    }
    
    func getItemDetails(itemId: Int, completion: @escaping (ApiResult<ItemDatails?>) -> Void) {
        completion(.success(nil))
    }
    
    func getSimilarItems(itemId: Int, completion: @escaping (ApiResult<[SimilarItem]?>) -> Void) {
        completion(.success(nil))
    }

}

class MainModuleTest: XCTestCase {
    var presenter: MainPresenter!
    var view: MockMainView!
    var networkService: NetworkService!
    var requestBuilder: RequestBuilder!
    var router: MockRouter!
    override func setUp() {
        view = MockMainView()
        requestBuilder = RequestBuilder()
        networkService = NetworkService(requestBuilder: requestBuilder)
        router = MockRouter()
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
    }

    override func tearDown() {
        view = nil
        requestBuilder = nil
        networkService = nil
        router = nil
        presenter = nil
    }

    func testModuleNotNil() {
        XCTAssertNotNil(view)
        XCTAssertNotNil(requestBuilder)
        XCTAssertNotNil(networkService)
        XCTAssertNotNil(router)
        XCTAssertNotNil(presenter)
    }
    
    func testViewSuccess() {
        presenter.getItemsPage(pageNumb: 1)
        let asyncExpectation = expectation(description: "success() completed")
        self.view.asyncSuccessExpectation = asyncExpectation
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail()
            }
            XCTAssertEqual(self.view?.testSuccess, "Success")
        }
    }
    
    func testViewFailure() {
        presenter = MainPresenter(view: view, networkService: MockNetworkService(requestBuilder: requestBuilder), router: router)
        presenter.getItemsPage(pageNumb: 0)
        let asyncExpectation = expectation(description: "failure completed")
        self.view.asyncFailExpectation = asyncExpectation
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail()
            }
            XCTAssertNotNil(self.view.testFailure)
        }
        
    }
    
    func testShowAnimation() {
        
        let asyncExpectation = expectation(description: "Async block executed")
        DispatchQueue.main.async {
            self.presenter.getItemsPage(pageNumb: 1)
            guard let isIndicatorAnimating = self.view?.activityIndicator.isAnimating else {
                XCTFail()
                asyncExpectation.fulfill()
                return
            }
            XCTAssertTrue(isIndicatorAnimating)
            asyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testHideAnimation() {
        presenter.getItemsPage(pageNumb: 1)
        let asyncExpectation = expectation(description: "hideActivityIndicator() completed")
        self.view.asyncHideExpectation = asyncExpectation
        waitForExpectations(timeout: 10) { error in
            
            guard let isIndicatorAnimating = self.view?.activityIndicator.isAnimating else {
                XCTFail()
                return
            }
            XCTAssertFalse(isIndicatorAnimating)
        }
    }
    
    func testTapOnTheItem() {
        presenter.tapOnTheItem(itemId: 1)
        XCTAssertTrue(router.itemId == 1)
    }
    
    func testLastPage() {
        presenter.getItemsPage(pageNumb: 999999)
        let asyncExpectation = expectation(description: "last page completed")
        self.view.asyncLastPageExpectation = asyncExpectation
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail()
            }
            XCTAssertTrue(self.presenter.lastPage)
        }
    }
}
