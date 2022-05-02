//
//  PostsUserStory.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Swinject
import Module

public protocol PostsRouteMap: AnyObject {
    func userPostsModule() -> ModuleProtocol
    func allPostsModule() -> ModuleProtocol
}

public final class PostsUserStory {
    private let container: Container
    private var outputWrapper: RootModuleWrapper?
    public init(container: Container) {
        self.container = container
    }
}

extension PostsUserStory: PostsRouteMap {
    public func allPostsModule() -> ModuleProtocol {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
    
    public func userPostsModule() -> ModuleProtocol {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension PostsUserStory: RouteMapPrivate {
    func module() -> ModuleProtocol {
        let module =
        module.output = outputWrapper
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
