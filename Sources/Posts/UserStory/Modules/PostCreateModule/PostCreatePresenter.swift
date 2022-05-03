//
//  PostCreatePresenter.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AlertManager

protocol PostCreateStringFactoryProtocol {
    var sendButtonImageName: String { get }
    var textViewPlaceholderText: String { get }
    var removeButtonImageName: String { get }
    var successCreatedPost: String { get }
}

protocol PostCreateModuleOutput: AnyObject {
    
}

protocol PostCreateModuleInput: AnyObject {
    
}

protocol PostCreateViewOutput: AnyObject {
    func viewDidLoad()
    func select(image: UIImage, with size: CGSize)
    func entered(text: String)
    func removeSelectedImage()
    func createPost(text: String?)
    func keyboardDidShow()
}

final class PostCreatePresenter {
    
    weak var view: PostCreateViewInput?
    weak var output: PostCreateModuleOutput?
    private let router: PostCreateRouterInput
    private let interactor: PostCreateInteractorInput
    private let stringFactory: PostCreateStringFactoryProtocol
    private let alertManager: AlertManagerProtocol
    private var enteredText: String?
    private var selectedImageInfo: (image: UIImage, size: CGSize)?
    
    init(router: PostCreateRouterInput,
         interactor: PostCreateInteractorInput,
         stringFactory: PostCreateStringFactoryProtocol,
         alertManager: AlertManagerProtocol) {
        self.router = router
        self.interactor = interactor
        self.stringFactory = stringFactory
        self.alertManager = alertManager
    }
}

extension PostCreatePresenter: PostCreateViewOutput {

    func entered(text: String) {
        self.enteredText = text
        let result = enteredText != "" || selectedImageInfo != nil
        view?.sendButtonEnabled(on: result)
    }

    func keyboardDidShow() {
        view?.setupInitialLayout()
    }
    
    func viewDidLoad() {
        view?.setupInitialState(stringFactory: stringFactory)
        view?.setupInitialLayout()
        view?.sendButtonEnabled(on: false)
    }
    
    func select(image: UIImage, with size: CGSize) {
        self.selectedImageInfo = (image, size)
        view?.successSelectedPhoto(photo: image, photo: size)
        view?.sendButtonEnabled(on: true)
    }
    
    func removeSelectedImage() {
        self.selectedImageInfo = nil
        view?.setupInitialLayout()
        let result = enteredText != ""
        view?.sendButtonEnabled(on: result)
        
    }
    
    func createPost(text: String?) {
        view?.blockUI()
        interactor.createPost(text: text,
                              image: selectedImageInfo?.image,
                              size: selectedImageInfo?.size)
    }
    
    
}

extension PostCreatePresenter: PostCreateInteractorOutput {
    func successCreatedPost() {
        alertManager.present(type: .success, title: stringFactory.successCreatedPost)
        view?.unlockUI()
        router.dismissModule()
    }
    
    func failureCreatePost(message: String) {
        alertManager.present(type: .error, title: message)
        view?.unlockUI()
    }
}

extension PostCreatePresenter: PostCreateModuleInput {
    
}
