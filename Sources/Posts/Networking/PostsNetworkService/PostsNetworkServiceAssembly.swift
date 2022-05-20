//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Swinject
import FirebaseFirestore

final class PostsNetworkServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PostsNetworkServiceProtocol.self) { r in
            PostsNetworkService(networkService: Firestore.firestore())
        }
    }
}
