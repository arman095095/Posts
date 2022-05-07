//
//  RouteMapPrivate.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import ProfileRouteMap
import ModelInterfaces

protocol RouteMapPrivate: AnyObject {
    func postsListModule(context: InputFlowContext) -> PostsListModule
    func postCreateModule(output: PostCreateModuleOutput) -> PostCreateModule
    func profileModule(profile: ProfileModelProtocol,
                       output: ProfileModuleOutput) -> ProfileModule
}
