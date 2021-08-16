//
//  PhotoModel.swift
//  Photos_Demo
//
//  Created by Pramod Shukla on 16/08/21.
//

import Foundation

// MARK: - Welcome
struct Photo: Codable {
    let status: String
    let media: [Media]
}

// MARK: - Media
struct Media: Codable {
    let mediaID: Int
    let media: String
    let isProfileimage: Int

    enum CodingKeys: String, CodingKey {
        case mediaID = "media_id"
        case media
        case isProfileimage = "is_profileimage"
    }
}
