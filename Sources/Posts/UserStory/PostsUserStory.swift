//
//  PostsUserStory.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Swinject
import Module
import Managers
import AlertManager

public protocol PostsRouteMap: AnyObject {
    func allPostsModule() -> PostsModule
    func userPostsModule(userID: String, userName: String) -> PostsModule
    func currentAccountPostsModule(userID: String) -> PostsModule
}

public final class PostsUserStory {
    private let container: Container
    private var outputWrapper: RootModuleWrapper?
    public init(container: Container) {
        self.container = container
    }
}

extension PostsUserStory: PostsRouteMap {

    public func allPostsModule() -> PostsModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .allPosts)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
    
    public func userPostsModule(userID: String, userName: String) -> PostsModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .user(id: userID, userName: userName))
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
    
    public func currentAccountPostsModule(userID: String) -> PostsModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self, context: .currentUser(id: userID))
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension PostsUserStory: RouteMapPrivate {
    func postsListModule(context: InputFlowContext) -> PostsListModule {
        let safeResolver = container.synchronize()
        guard let postManager = safeResolver.resolve(PostsManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = PostsListAssembly.makeModule(postManager: postManager,
                                                  alertManager: alertManager,
                                                  context: context,
                                                  routeMap: self)
        module.output = outputWrapper
        return module
    }
    
    func postCreateModule(output: PostCreateModuleOutput) -> PostCreateModule {
        let safeResolver = container.synchronize()
        guard let postManager = safeResolver.resolve(PostsManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = PostCreateAssembly.makeModule(postManager: postManager,
                                                   alertManager: alertManager)
        module.output = output
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
