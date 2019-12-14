//
//  RequestBuilder.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import Foundation

protocol RequestBuilderProtocol {
    func getItemsPageRequest(pageNum: Int) -> URLRequest?
    func getItemDetailsRequest(itemId: Int) -> URLRequest?
    func getSimilarItemsRequest(itemId: Int) -> URLRequest?
}

class RequestBuilder: RequestBuilderProtocol {
    private let baseUrl = "http://testwork.nsd.naumen.ru/rest/computers"
    
    func getItemsPageRequest(pageNum: Int) -> URLRequest? {
        let urlStr = "\(baseUrl)?p=\(pageNum)"
        guard let url = URL(string: urlStr) else { return nil }
        return URLRequest(url: url)
    }
    
    func getItemDetailsRequest(itemId: Int) -> URLRequest? {
           let urlStr = "\(baseUrl)/\(itemId)"
           guard let url = URL(string: urlStr) else { return nil }
           return URLRequest(url: url)
    }
    
    func getSimilarItemsRequest(itemId: Int) -> URLRequest? {
        let urlStr = "\(baseUrl)/\(itemId)/similar"
        guard let url = URL(string: urlStr) else { return nil }
        return URLRequest(url: url)
    }
}
