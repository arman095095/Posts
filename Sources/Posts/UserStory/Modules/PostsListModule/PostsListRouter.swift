//
//  PostsListRouter.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import ModelInterfaces

protocol PostsListRouterInput: AnyObject {
    func openPostCreationModule(output: PostCreateModuleOutput)
    func openMenuAlert(preserved: IndexPath)
    func openUserProfile(_ profile: ProfileModelProtocol)
}

protocol PostsListRouterOutput: AnyObject {
    func delete(preserved: IndexPath)
}

final class PostsListRouter {
    weak var transitionHandler: UIViewController?
    weak var output: PostsListRouterOutput?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension PostsListRouter: PostsListRouterInput {

    func openUserProfile(_ profile: ProfileModelProtocol) {
        let module = routeMap.profileModule(profile: profile)
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }

    func openMenuAlert(preserved: IndexPath) {
        transitionHandler?.showAlertDelete(acceptHandler: {
            self.output?.delete(preserved: preserved)
        }, denyHandler: { })
    }
    
    func openPostCreationModule(output: PostCreateModuleOutput) {
        let module = routeMap.postCreateModule(output: output)
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
}
