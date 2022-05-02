//
//  RootModuleWrapperAssembly.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module

typealias PostsModule = Module<PostsModuleInput, PostsModuleOutput>

enum RootModuleWrapperAssembly {
    static func makeModule(routeMap: RouteMapPrivate) -> PostsModule {
        let wrapper = RootModuleWrapper(routeMap: routeMap)
        return PostsModule(input: wrapper, view: wrapper.view()) {
            wrapper.output = $0
        }
    }
}
