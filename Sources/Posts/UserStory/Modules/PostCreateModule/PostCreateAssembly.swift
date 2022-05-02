//
//  PostCreateAssembly.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module

typealias PostCreateModule = Module<PostCreateModuleInput, PostCreateModuleOutput>

enum PostCreateAssembly {
    static func makeModule() -> PostCreateModule {
        let view = PostCreateViewController()
        let router = PostCreateRouter()
        let interactor = PostCreateInteractor()
        let presenter = PostCreatePresenter(router: router, interactor: interactor)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return PostCreateModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
