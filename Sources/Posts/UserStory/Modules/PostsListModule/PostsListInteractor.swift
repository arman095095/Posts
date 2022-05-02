//
//  PostsListInteractor.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PostsListInteractorInput: AnyObject {
    func requestFirstPosts(userID: String)
    func requestNextPosts(userID: String)
    func requestFirstPosts()
    func requestNextPosts()
}

protocol PostsListInteractorOutput: AnyObject {
    
}

final class PostsListInteractor {
    
    weak var output: PostsListInteractorOutput?
    private let postsManager: PostsManagerProtocol
    
    init(postsManager: PostsManagerProtocol) {
        self.postsManager = postsManager
    }
}

extension PostsListInteractor: PostsListInteractorInput {

    func requestFirstPosts() {
        
    }

    func requestNextPosts() {
        
    }
    
    func requestFirstPosts(userID: String) {
        
    }
    
    func requestNextPosts(userID: String) {
        
    }
}
