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
    
    func testURLRequest() {
        XCTAssertEqual(requestBuilder.getItemsPageRequest(pageNum: 1), URLRequest(url: URL(string: "http://testwork.nsd.naumen.ru/rest/computers?p=1")!))
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

}
