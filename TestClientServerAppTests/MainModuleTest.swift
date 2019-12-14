//
//  MainModuleTest.swift
//  TestClientServerAppTests
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import XCTest
@testable import TestClientServerApp

class MockView: MainViewProtocol {
    var testSuccess: String?
    var testFailure: String?
    var activityIndicator = UIActivityIndicatorView()
    var asyncSuccessExpectation: XCTestExpectation?
    var asyncHideExpectation: XCTestExpectation?
    
    func success() {
        print("success")
        self.testSuccess = "Success"
        asyncSuccessExpectation?.fulfill()
    }
    
    func failure(error: Error) {
        self.testFailure = "Failure"
        //asyncExpectation?.fulfill()
    }
    
    func showActivityIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        print("hide")
        asyncHideExpectation?.fulfill()
    }
}

class MainModuleTest: XCTestCase {
    var presenter: MainPresenter!
    var view: MockView!
    var networkService: NetworkService!
    var requestBuilder: RequestBuilder!

    override func setUp() {
        view = MockView()
        requestBuilder = RequestBuilder()
        networkService = NetworkService(requestBuilder: requestBuilder)
        presenter = MainPresenter(view: view, networkService: networkService)
    }

    override func tearDown() {
        view = nil
        requestBuilder = nil
        networkService = nil
        presenter = nil
    }

    func testModuleNotNil() {
        XCTAssertNotNil(view)
        XCTAssertNotNil(requestBuilder)
        XCTAssertNotNil(networkService)
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
    
//    func testViewFailure() {
//        presenter.getItemsPage(pageNumb: 15511515)
//        let asyncExpectation = expectation(description: "Async block executed")
//        self.view.asyncExpectation = asyncExpectation
//        waitForExpectations(timeout: 10) { error in
//            XCTAssertEqual(self.view?.testFailure, "Failure")
//        }
//        //waitForExpectations(timeout: 10, handler: nil)
//    }
    
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

}
