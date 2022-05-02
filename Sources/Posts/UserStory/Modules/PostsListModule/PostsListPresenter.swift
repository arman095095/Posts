//
//  PostsListPresenter.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem
import Managers
import AlertManager

protocol PostsListModuleOutput: AnyObject {
    
}

protocol PostsListModuleInput: AnyObject {
    
}

protocol PostsListViewOutput: AnyObject {
    var tabBarHidden: Bool { get }
    var title: String { get }
    var postsTitleHeight: CGFloat { get }
    var infoTitleHeight: CGFloat { get }
    var infoTitleText: String { get }
    func viewDidLoad()
    func requestPosts()
    func requestMorePosts()
    func post(at indexPath: IndexPath) -> PostCellViewModel
    func rowHeight(at indexPath: IndexPath) -> CGFloat
}

enum InputFlowContext: Equatable {
    case user(id: String, userName: String)
    case currentUser(id: String)
    case allPosts
}

protocol PostsListStringFactoryProtocol {
    var allPostsTitle: String { get }
    var userPostsTitle: String { get }
    var currentUserPostsTitle: String { get }
    var mainEmptyTitle: String { get }
    var currentUserEmptyTitle: String { get }
    var userEmptyTitle: String { get }
}

final class PostsListPresenter {
    
    weak var view: PostsListViewInput?
    weak var output: PostsListModuleOutput?
    private let router: PostsListRouterInput
    private let interactor: PostsListInteractorInput
    private let stringFactory: PostsListStringFactoryProtocol
    private let alertManager: AlertManagerProtocol
    private let frameCalculator: FrameCalculatorProtocol
    private let context: InputFlowContext
    private var posts: [PostCellViewModel]
    
    init(router: PostsListRouterInput,
         interactor: PostsListInteractorInput,
         alertManager: AlertManagerProtocol,
         frameCalculator: FrameCalculatorProtocol,
         context: InputFlowContext) {
        self.router = router
        self.interactor = interactor
        self.context = context
        self.alertManager = alertManager
        self.frameCalculator = frameCalculator
        self.posts = []
    }
}

extension PostsListPresenter: PostsListViewOutput {
    var postsTitleHeight: CGFloat {
        switch context {
        case .user:
            return Constants.zero
        case .allPosts, .currentUser:
            return Constants.titleViewHeight
        }
    }
    
    var infoTitleHeight: CGFloat {
        posts.isEmpty ? Constants.infoTitleHeight : Constants.zero
    }

    var title: String {
        switch context {
        case .user(_, let userName):
            return stringFactory.userPostsTitle + " " + userName
        case .currentUser:
            return stringFactory.currentUserPostsTitle
        case .allPosts:
            return stringFactory.allPostsTitle
        }
    }

    var infoTitleText: String {
        switch context {
        case .user:
            return stringFactory.userEmptyTitle
        case .currentUser:
            return stringFactory.currentUserEmptyTitle
        case .allPosts:
            return stringFactory.mainEmptyTitle
        }
    }
    
    var tabBarHidden: Bool {
        return context != .allPosts
    }
    
    func viewDidLoad() {
        view?.setupInitialState()
        requestPosts()
    }
    
    func post(at indexPath: IndexPath) -> PostCellViewModel {
        posts[indexPath.row]
    }
    
    func rowHeight(at indexPath: IndexPath) -> CGFloat {
        posts[indexPath.row].frames?.height ?? 0
    }
    
    func requestPosts() {
        view?.setLoad(on: true)
        switch context {
        case .allPosts:
            interactor.requestFirstPosts()
        case .user(let id, _), .currentUser(let id):
            interactor.requestFirstPosts(userID: id)
        }
    }
    
    func requestMorePosts() {
        view?.setFooterLoad(on: true)
        switch context {
        case .allPosts:
            interactor.requestNextPosts()
        case .user(let id, _), .currentUser(let id):
            interactor.requestNextPosts(userID: id)
        }
    }
}

extension PostsListPresenter: ListsHeaderTitleViewOutput {
    func mainButtonAction() {
        switch context {
        case .allPosts, .currentUser:
            router.openPostCreationModule()
        case .user:
            break
        }
    }
}

extension PostsListPresenter: PostsListInteractorOutput {

    func successLoadedAllFirstPosts(_ posts: [PostModelProtocol]) {
        handlePosts(models: posts) { cellViewModels in
            self.posts = cellViewModels
            view?.setLoad(on: false)
        }
    }
    
    func successLoadedAllNextPosts(_ posts: [PostModelProtocol]) {
        handlePosts(models: posts) { cellViewModels in
            self.posts.append(contentsOf: cellViewModels)
            view?.setFooterLoad(on: false)
        }
    }
    
    func successLoadedUserFirstPosts(_ posts: [PostModelProtocol]) {
        handlePosts(models: posts) { cellViewModels in
            self.posts = cellViewModels
            view?.setLoad(on: false)
        }
    }
    
    func successLoadedUserNextPosts(_ posts: [PostModelProtocol]) {
        handlePosts(models: posts) { cellViewModels in
            self.posts.append(contentsOf: cellViewModels)
            self.view?.setFooterLoad(on: false)
            self.view?.reloadData(posts: self.posts)
        }
    }
    
    func failureLoadAllFirstPosts(message: String) {
        view?.setLoad(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func failureLoadAllNextPosts(message: String) {
        view?.setFooterLoad(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func failureLoadUserFirstPosts(message: String) {
        view?.setLoad(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func failureLoadUserNextPosts(message: String) {
        view?.setFooterLoad(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    
}

extension PostsListPresenter: PostsListModuleInput { }

private extension PostsListPresenter {
    struct Constants {
        static let zero: CGFloat = 0
        static let infoTitleHeight: CGFloat = 250
        static let titleViewHeight: CGFloat = 60
    }
}

private extension PostsListPresenter {
    func handlePosts(models: [PostModelProtocol], completion: ([PostCellViewModel]) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let cellModels: [PostCellViewModel] = models.map {
                let cellViewModel = PostCellViewModel(model: $0)
                let frames = self.framesCalculator.calculate(model: cellViewModel)
                cellViewModel.frames = frames.visibleFrame
                cellViewModel.realFrames = frames.realFrame
                return cellViewModel
            }
            completion(cellModels)
        }
    }
}
