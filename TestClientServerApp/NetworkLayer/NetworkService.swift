//
//  NetworkService.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    init(requestBuilder: RequestBuilderProtocol)
    func getItemsPage(pageNumb: Int, completion: @escaping (ApiResult<ItemsPage?>) -> Void)
    func getItemDetails(itemId: Int, completion: @escaping (ApiResult<ItemDatails?>) -> Void)
    func getSimilarItems(itemId: Int, completion: @escaping (ApiResult<[SimilarItem]?>) -> Void)
}

enum ApiResult<Value> {
    case success(Value)
    case failure(Error)
}

class NetworkService: NetworkServiceProtocol {
    private let requestBuilder: RequestBuilderProtocol!
    private let decoder = JSONDecoder()
    
    required init(requestBuilder: RequestBuilderProtocol) {
        self.requestBuilder = requestBuilder
    }
    
    func getItemsPage(pageNumb: Int, completion: @escaping (ApiResult<ItemsPage?>) -> Void) {
        guard let request = self.requestBuilder.getItemsPageRequest(pageNum: pageNumb) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Can't get request from requestBuilder"])
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            self.decode(responseData: data, responseError: error, completion: completion)
        }.resume()
    }
    
    func getItemDetails(itemId: Int, completion: @escaping (ApiResult<ItemDatails?>) -> Void) {
        print("getItemDetails from API")
        guard let request = self.requestBuilder.getItemDetailsRequest(itemId: itemId) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Can't get request from requestBuilder"])
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            self.decode(responseData: data, responseError: error, completion: completion)
        }.resume()
    }
    
    func getSimilarItems(itemId: Int, completion: @escaping (ApiResult<[SimilarItem]?>) -> Void) {
        guard let request = self.requestBuilder.getSimilarItemsRequest(itemId: itemId) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Can't get request from requestBuilder"])
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
            self.decode(responseData: data, responseError: error, completion: completion)
        }.resume()
    }
    
    private func decode<D: Decodable>(responseData: Data?, responseError: Error?, completion: (ApiResult<D>) -> Void) {
        if let error = responseError {
            completion(.failure(error))
        } else if let jsonData = responseData {
            do {
                let decodedData = try JSONDecoder().decode(D.self, from: jsonData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
            completion(.failure(error))
        }
    }
}
