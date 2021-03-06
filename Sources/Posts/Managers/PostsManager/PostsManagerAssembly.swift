//
//  File.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//

import Foundation
import Swinject
import NetworkServices
import Managers
import Services

final class PostsManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PostsManagerProtocol.self) { r in
            guard let remoteStorage = r.resolve(PostsRemoteStorageServiceProtocol.self),
                  let quickAccessManager = r.resolve(QuickAccessManagerProtocol.self),
                  let profileService = r.resolve(ProfileInfoNetworkServiceProtocol.self),
                  let postsServices = r.resolve(PostsNetworkServiceProtocol.self),
                  let accountID = quickAccessManager.userID else { fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return PostsManager(accountID: accountID,
                                postsService: postsServices,
                                remoteStorage: remoteStorage,
                                profilesService: profileService)
        }.inObjectScope(.weak)
    }
}
