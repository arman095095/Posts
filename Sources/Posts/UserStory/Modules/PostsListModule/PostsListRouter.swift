//
//  PostsListRouter.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PostsListRouterInput: AnyObject {
    func openPostCreationModule()
}

final class PostsListRouter {
    weak var transitionHandler: UIViewController?
}

extension PostsListRouter: PostsListRouterInput {
    func openPostCreationModule() {
        //
    }
}
