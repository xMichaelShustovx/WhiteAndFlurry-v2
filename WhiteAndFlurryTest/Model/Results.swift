//
//  Results.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import Foundation

struct Results: Decodable {
    var total: Int
    var results: [Result]
}

struct Result: Decodable {
    var id: String
    var created_at: String
    var user: User
    var urls: URLs
    var location: Location?
    var downloads: Int?
    var imageData: Data?
}

struct User: Decodable {
    var name: String
}

struct URLs: Decodable {
    var small: String
}

struct Location: Decodable {
    var name: String?
}
