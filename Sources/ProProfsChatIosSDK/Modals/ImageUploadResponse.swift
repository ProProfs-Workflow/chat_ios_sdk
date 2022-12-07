//
//  ImageUploadResponse.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 02/11/22.
//

import Foundation

struct ImageUploadResponse: Codable {
    let error: Int
    let file_name: String
    let id: Int
}
