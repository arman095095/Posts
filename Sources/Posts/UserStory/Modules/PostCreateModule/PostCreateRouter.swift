//
//  PostCreateRouter.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PostCreateRouterInput: AnyObject {
    func dismissModule()
}

final class PostCreateRouter {
    weak var transitionHandler: UIViewController?
}

extension PostCreateRouter: PostCreateRouterInput {
    func dismissModule() {
        transitionHandler?.navigationController?.dismiss(animated: true)
    }
}
