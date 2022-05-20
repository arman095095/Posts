//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation

struct URLComponents {

    enum Paths: String {
        case users
        case likers
        case posts
    }

    enum Parameters: String {
        case id
        case date
        case userID
        case textContent
        case imageHeight
        case imageWidth
        case urlImage
    }
}


struct StorageURLComponents {
    
    enum Parameters: String {
        case imageJpeg = "image/jpeg"
    }
    
    enum Paths: String {
        case posts = "Posts"
    }
}
