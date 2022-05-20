//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Swinject
import FirebaseStorage

final class PostsRemoteStorageServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PostsRemoteStorageServiceProtocol.self) { r in
            PostsRemoteStorageService(storage: Storage.storage())
        }
    }
}
