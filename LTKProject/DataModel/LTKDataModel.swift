//
//  LTKDataModel.swift
//  PageControl
//
//  Created by Ben Fitzgearl  on 5/5/22.
//

import Foundation

struct LTKData: Codable {
    let ltks: [LTK]
    let profiles: [LTKProfile]
    let products: [LTKProduct]
}

struct LTK: Codable {
    let hero_image: String
    let id: String
    let profile_id: String
    let caption: String
    let imageData: Data?
    let product_ids: [String]
}

struct LTKProfile: Codable {
    let id: String
    let avatar_url: String
    let display_name: String
}

struct LTKProduct: Codable {
    let id: String
    let hyperlink: String
    let image_url: String
}
