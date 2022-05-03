//
//  RootModuleWrapperAssembly.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module

public typealias PostsModule = Module<PostsModuleInput, PostsModuleOutput>

enum RootModuleWrapperAssembly {
    static func makeModule(routeMap: RouteMapPrivate, context: InputFlowContext) -> PostsModule {
        let wrapper = RootModuleWrapper(routeMap: routeMap)
        return PostsModule(input: wrapper, view: wrapper.view(context: context)) {
            wrapper.output = $0
        }
    }
}
