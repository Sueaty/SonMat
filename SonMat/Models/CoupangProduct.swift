//
//  CoupangProduct.swift
//  SonMat
//

import Foundation

struct CoupangProduct: Identifiable, Codable, Hashable {
    let name: String
    let thumbnailURL: String
    let productURL: String

    var id: String { productURL }

    enum CodingKeys: String, CodingKey {
        case name
        case thumbnailURL = "thumbnail_url"
        case productURL = "product_url"
    }
}
