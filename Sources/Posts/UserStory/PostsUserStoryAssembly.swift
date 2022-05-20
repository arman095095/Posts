//
//  PostsUserStoryAssembly.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Swinject
import PostsRouteMap
import UserStoryFacade

public final class PostsUserStoryAssembly: Assembly {
    
    public init() { }

    public func assemble(container: Container) {
        ProfileInfoNetworkServiceAssembly().assemble(container: container)
        PostsNetworkServiceAssembly().assemble(container: container)
        PostsRemoteStorageServiceAssembly().assemble(container: container)
        PostsManagerAssembly().assemble(container: container)
        container.register(PostsRouteMap.self) { r in
            PostsUserStory(container: container)
        }
    }
}
