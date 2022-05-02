//
//  PostsListAssembly.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module

typealias PostsListModule = Module<PostsListModuleInput, PostsListModuleOutput>

enum PostsListAssembly {
    static func makeModule() -> PostsListModule {
        let view = PostsListViewController()
        let router = PostsListRouter()
        let interactor = PostsListInteractor()
        let presenter = PostsListPresenter(router: router,
                                           interactor: interactor)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return PostsListModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
