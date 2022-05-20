//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation

struct PostsURLComponents {

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

struct ProfileURLComponents {

    enum Paths: String {
        case users
        case friendIDs
        case waitingUsers
        case sendedRequests
        case blocked
        case posts
    }

    enum Parameters: String {
        case uid
        case username
        case info
        case sex
        case lastActivity
        case online
        case removed
        case imageURL
        case birthday
        case country
        case city
        case id
    }
}
