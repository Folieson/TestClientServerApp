//
//  NetworkLayerTests.swift
//  TestClientServerAppTests
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import XCTest
@testable import TestClientServerApp

class NetworkLayerTests: XCTestCase {
    
    var requestBuilder: RequestBuilder!
    var networkService: NetworkService!

    override func setUp() {
        requestBuilder = RequestBuilder()
        networkService = NetworkService(requestBuilder: requestBuilder)
    }

    override func tearDown() {
        requestBuilder = nil
        networkService = nil
    }

    func testLayerNotNil() {
        XCTAssertNotNil(requestBuilder)
        XCTAssertNotNil(networkService)
    }
    
    func testURLRequests() {
        XCTAssertEqual(requestBuilder.getItemsPageRequest(pageNum: 1), URLRequest(url: URL(string: "http://testwork.nsd.naumen.ru/rest/computers?p=1")!))
        XCTAssertEqual(requestBuilder.getItemDetailsRequest(itemId: 71), URLRequest(url: URL(string: "http://testwork.nsd.naumen.ru/rest/computers/71")!))
        XCTAssertEqual(requestBuilder.getSimilarItemsRequest(itemId: 71), URLRequest(url: URL(string: "http://testwork.nsd.naumen.ru/rest/computers/71/similar")!))
    }
    
    func testGetItemsPage() {
        networkService.getItemsPage(pageNumb: 1, completion: { result in
            switch result {
            case .success(let itemsPage):
                XCTAssertEqual(itemsPage?.page, 1)
                XCTAssertNotNil(itemsPage?.items)
                XCTAssertNotNil(itemsPage?.offset)
                XCTAssertNotNil(itemsPage?.total)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
    }
    
    func testGetItemDerails() {
        networkService.getItemDetails(itemId: 71, completion: { result in
            switch result {
            case .success(let itemDetails):
                XCTAssertEqual(itemDetails?.id, 71)
                XCTAssertEqual(itemDetails?.name, "Amiga 1000")
                XCTAssertNil(itemDetails?.introduced)
                XCTAssertEqual(itemDetails?.imageUrl, "https://www.overclockers.ru/images/news/2016/07/28/LeanovoAir13Pro_01.jpg")
                XCTAssertEqual(itemDetails?.company?.id, 6)
                XCTAssertNotNil(itemDetails?.company?.name)
                XCTAssertNotNil(itemDetails?.description)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
    }
    
    func testGetSimilarItems() {
        networkService.getSimilarItems(itemId: 71, completion: { result in
            switch result {
            case .success(let similarItems):
                XCTAssertEqual(similarItems?.count, 5)
                XCTAssertEqual(similarItems?[0].id, 72)
                XCTAssertEqual(similarItems?[0].name, "Amiga 500")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
    }

}
