//
//  PostCreateInteractor.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers

protocol PostCreateInteractorInput: AnyObject {
    func createPost(text: String?, image: UIImage?, size: CGSize?)
}

protocol PostCreateInteractorOutput: AnyObject {
    func successCreatedPost()
    func failureCreatePost(message: String)
}

final class PostCreateInteractor {
    
    weak var output: PostCreateInteractorOutput?
    private let postsManager: PostsManagerProtocol
    
    init(postsManager: PostsManagerProtocol) {
        self.postsManager = postsManager
    }
}

extension PostCreateInteractor: PostCreateInteractorInput {
    func createPost(text: String?, image: UIImage?, size: CGSize?) {
        postsManager.create(image: image, imageSize: size, content: (text ?? "")) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successCreatedPost()
            case .failure(let error):
                self?.output?.failureCreatePost(message: error.localizedDescription)
            }
        }
    }
}
