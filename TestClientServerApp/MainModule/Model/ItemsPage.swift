//
//  ItemsPage.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import Foundation

// MARK: - ItemsPage
struct ItemsPage: Codable {
    let items: [Item]?
    let page, offset, total: Int?
}

// MARK: - Item
struct Item: Codable {
    let id: Int?
    let name: String?
    let company: Company?
}

// MARK: - Company
struct Company: Codable {
    let id: Int?
    let name: String?
}
