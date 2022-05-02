//
//  PostsListInteractor.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers

protocol PostsListInteractorInput: AnyObject {
    var isExecuting: Bool { get }
    func requestFirstPosts(userID: String)
    func requestNextPosts(userID: String)
    func requestFirstPosts()
    func requestNextPosts()
}

protocol PostsListInteractorOutput: AnyObject {
    func successLoadedAllFirstPosts(_ posts: [PostModelProtocol])
    func successLoadedAllNextPosts(_ posts: [PostModelProtocol])
    func successLoadedUserFirstPosts(_ posts: [PostModelProtocol])
    func successLoadedUserNextPosts(_ posts: [PostModelProtocol])
    
    func failureLoadAllFirstPosts(message: String)
    func failureLoadAllNextPosts(message: String)
    func failureLoadUserFirstPosts(message: String)
    func failureLoadUserNextPosts(message: String)
}

final class PostsListInteractor {
    
    weak var output: PostsListInteractorOutput?
    private let postsManager: PostsManagerProtocol
    var isExecuting: Bool
    
    init(postsManager: PostsManagerProtocol) {
        self.postsManager = postsManager
    }
}

extension PostsListInteractor: PostsListInteractorInput {

    func requestFirstPosts() {
        guard !isExecuting else { return }
        isExecuting = true
        postsManager.getAllFirstPosts { [weak self] result in
            defer { self?.isExecuting = false }
            switch result {
            case .success(let posts):
                self?.output?.successLoadedAllFirstPosts(posts)
            case .failure(let error):
                self?.output?.failureLoadAllFirstPosts(message: error.localizedDescription)
            }
        }
    }

    func requestNextPosts() {
        guard !isExecuting else { return }
        isExecuting = true
        postsManager.getAllNextPosts { [weak self] result in
            defer { self?.isExecuting = false }
            switch result {
            case .success(let posts):
                self?.output?.successLoadedAllNextPosts(posts)
            case .failure(let error):
                self?.output?.failureLoadAllNextPosts(message: error.localizedDescription)
            }
        }
    }
    
    func requestFirstPosts(userID: String) {
        guard !isExecuting else { return }
        isExecuting = true
        postsManager.getFirstPosts(for: userID) { [weak self] result in
            defer { self?.isExecuting = false }
            switch result {
            case .success(let posts):
                self?.output?.successLoadedUserFirstPosts(posts)
            case .failure(let error):
                self?.output?.failureLoadUserFirstPosts(message: error.localizedDescription)
            }
        }
    }
    
    func requestNextPosts(userID: String) {
        guard !isExecuting else { return }
        isExecuting = true
        postsManager.getNextPosts(for: userID) { [weak self] result in
            defer { self?.isExecuting = false }
            switch result {
            case .success(let posts):
                self?.output?.successLoadedUserNextPosts(posts)
            case .failure(let error):
                self?.output?.failureLoadUserNextPosts(message: error.localizedDescription)
            }
        }
    }
}
