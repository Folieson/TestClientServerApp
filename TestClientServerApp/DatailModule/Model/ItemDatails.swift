//
//  ItemDatails.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import Foundation

struct ItemDatails: Codable {
    let id: Int?
    let name: String?
    let imageURL: String?
    let company: Company?
    let itemDatailsDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "imageUrl"
        case company
        case itemDatailsDescription = "description"
    }
}
