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
    static func makeModule(postManager: PostsManagerProtocol,
                           alertManager: AlertManagerProtocol,
                           context: InputFlowContext) -> PostsListModule {
        let view = PostsListViewController()
        let router = PostsListRouter()
        let interactor = PostsListInteractor(postsManager: postManager)
        let frameCalculator = FrameCalculator()
        let presenter = PostsListPresenter(router: router,
                                           interactor: interactor,
                                           alertManager: alertManager,
                                           frameCalculator: frameCalculator,
                                           context: context)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return PostsListModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}