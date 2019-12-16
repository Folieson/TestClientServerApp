//
//  DetailModuleTest.swift
//  TestClientServerAppTests
//
//  Created by Андрей Понамарчук on 16.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import XCTest
@testable import TestClientServerApp

class MockDetailView: DetailViewProtocol {
    var activityIndicator = UIActivityIndicatorView()
    var itemDetails: String?
    var similarItems: String?
    var asyncSetItemDetailsExpectation: XCTestExpectation?
    var asyncSetSimilarItemsExpectation: XCTestExpectation?
    var asyncHideExpectation: XCTestExpectation?
    
    func setItemDetails() {
        self.itemDetails = ""
        asyncSetItemDetailsExpectation?.fulfill()
        asyncSetItemDetailsExpectation = nil
    }
    
    func setSimilarItems() {
        self.similarItems = ""
        asyncSetSimilarItemsExpectation?.fulfill()
        asyncSetSimilarItemsExpectation = nil
    }
    
    func failure(error: Error) {
        
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

class DetailModuleTest: XCTestCase {
    var presenter: DetailPresenter!
    var view: MockDetailView!
    var networkService: MockNetworkService!
    var requestBuilder: RequestBuilderProtocol!
    var router: MockRouter!

    override func setUp() {
        view = MockDetailView()
        requestBuilder = RequestBuilder()
        networkService = MockNetworkService(requestBuilder: requestBuilder)
        router = MockRouter()
        presenter = DetailPresenter(view: view, networkService: networkService, router: router, itemId: 2)
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

    func testGetItemDetails() {
        presenter.getItemDetails()
        let asyncExpectation = expectation(description: "setItemDetails() completed")
        self.view.asyncSetItemDetailsExpectation = asyncExpectation
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail()
            }
            XCTAssertNotNil(self.view.itemDetails)
        }
    }
    
    func testGetSimilarItems() {
        presenter.getSimilarItems()
        let asyncExpectation = expectation(description: "setSimilarItems() completed")
        self.view.asyncSetSimilarItemsExpectation = asyncExpectation
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail()
            }
            XCTAssertNotNil(self.view.similarItems)
        }
    }
    
    func testReturnToTheMainScreen() {
        presenter.tapOnTheReturnToTheMainScreen()
        XCTAssertNotNil(self.router.popToRootOK) 
    }
    
    func testTapOnTheSimilarItem() {
        presenter.tapOnTheSimilarItem(itemId: 5)
        XCTAssertEqual(router.itemId, 5)
    }
    
    func testFormatDateFromISO8601() {
        let date = presenter.formatDateFromISO8601(date: "1980-04-30T19:00:00Z")
        XCTAssertEqual(date, "30 Apr 1980")
    }
    
    func testImageLoadData() {
        presenter.getImageData(urlString: "https://gizmod.ru/uploads/posts/2016-03/1457543403_noutbuki-serii-samsung-notebook-9-uje-v-prodaje-2.jpg")
        XCTAssertNotNil(presenter.itemImageData)
    }
    
    func testShowAnimation() {
        
        let asyncExpectation = expectation(description: "Async block executed")
        DispatchQueue.main.async {
            self.presenter.getSimilarItems()
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
        self.presenter.getSimilarItems()
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
