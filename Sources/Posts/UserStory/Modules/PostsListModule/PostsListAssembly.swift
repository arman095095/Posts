//
//  PostsListAssembly.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import Managers
import AlertManager

typealias PostsListModule = Module<PostsListModuleInput, PostsListModuleOutput>

enum PostsListAssembly {
    static func makeModule(accountID: String,
                           postManager: PostsManagerProtocol,
                           alertManager: AlertManagerProtocol,
                           context: InputFlowContext,
                           routeMap: RouteMapPrivate) -> PostsListModule {
        let view = PostsListViewController()
        let router = PostsListRouter(routeMap: routeMap)
        let interactor = PostsListInteractor(postsManager: postManager)
        let frameCalculator = FrameCalculator()
        let stringFactory = PostsStringFactory()
        let presenter = PostsListPresenter(router: router,
                                           interactor: interactor,
                                           alertManager: alertManager,
                                           stringFactory: stringFactory,
                                           frameCalculator: frameCalculator,
                                           context: context,
                                           accountID: accountID)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        router.output = presenter
        return PostsListModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
