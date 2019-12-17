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
    let introduced: String?
    let discounted: String?
    let imageUrl: String?
    let company: Company?
    let description: String?
}
