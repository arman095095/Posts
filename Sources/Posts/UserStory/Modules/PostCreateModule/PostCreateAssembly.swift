//
//  PostCreateAssembly.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import Managers
import AlertManager

typealias PostCreateModule = Module<PostCreateModuleInput, PostCreateModuleOutput>

enum PostCreateAssembly {
    static func makeModule(postManager: PostsManagerProtocol,
                           alertManager: AlertManagerProtocol) -> PostCreateModule {
        let view = PostCreateViewController()
        let router = PostCreateRouter()
        let interactor = PostCreateInteractor(postsManager: postManager)
        let stringFactory = PostsStringFactory()
        let presenter = PostCreatePresenter(router: router,
                                            interactor: interactor,
                                            stringFactory: stringFactory,
                                            alertManager: alertManager)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return PostCreateModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
