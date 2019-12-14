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
    func getItemsPage(pageNumb: Int, completion: @escaping (Result<ItemsPage?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let requestBuilder: RequestBuilderProtocol!
    required init(requestBuilder: RequestBuilderProtocol) {
        self.requestBuilder = requestBuilder
    }
    
    func getItemsPage(pageNumb: Int, completion: @escaping (Result<ItemsPage?, Error>) -> Void) {
        guard let request = self.requestBuilder.getItemsPageRequest(pageNum: pageNumb) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Can't get request from requestBuilder"])
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let itemsPage = try JSONDecoder().decode(ItemsPage.self, from: data)
                        completion(.success(itemsPage))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                   let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    completion(.failure(error))
                }
        }.resume()
    }
}
