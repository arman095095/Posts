//
//  RootModuleWrapper.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import PostsRouteMap

final class RootModuleWrapper {

    private let routeMap: RouteMapPrivate
    weak var output: PostsModuleOutput?
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }

    func view(context: InputFlowContext) -> UIViewController {
        let module = routeMap.postsListModule(context: context)
        module.output = self
        return module.view
    }
}

extension RootModuleWrapper: PostsModuleInput { }

extension RootModuleWrapper: PostsListModuleOutput { }
