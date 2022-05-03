//
//  PostsListRouter.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PostsListRouterInput: AnyObject {
    func openPostCreationModule(output: PostCreateModuleOutput)
    func openMenuAlert(preserved: IndexPath)
    func popToCurrentModule()
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
    func popToCurrentModule() {
        guard let transitionHandler = transitionHandler else { return }
        transitionHandler.navigationController?.popToViewController(transitionHandler, animated: true)
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
