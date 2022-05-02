//
//  PostCreatePresenter.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PostCreateModuleOutput: AnyObject {
    
}

protocol PostCreateModuleInput: AnyObject {
    
}

protocol PostCreateViewOutput: AnyObject {
    
}

final class PostCreatePresenter {
    
    weak var view: PostCreateViewInput?
    weak var output: PostCreateModuleOutput?
    private let router: PostCreateRouterInput
    private let interactor: PostCreateInteractorInput
    
    init(router: PostCreateRouterInput,
         interactor: PostCreateInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension PostCreatePresenter: PostCreateViewOutput {
    
}

extension PostCreatePresenter: PostCreateInteractorOutput {
    
}

extension PostCreatePresenter: PostCreateModuleInput {
    
}
