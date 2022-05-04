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
import ModelInterfaces

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
    var createPostTitle: String { get }
    func viewDidLoad()
    func viewWillAppear()
    func requestPosts()
    func requestMorePosts()
    func post(at indexPath: IndexPath) -> PostCellViewModelProtocol
    func reveal(at indexPath: IndexPath)
    func likePost(at indexPath: IndexPath)
    func presentMenu(at indexPath: IndexPath)
    func openUserProfile(at indexPath: IndexPath)
    func rowHeight(at indexPath: IndexPath) -> CGFloat
}

enum InputFlowContext: Equatable {
    case user(id: String)
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
    var createPostTitle: String { get }
}

final class PostsListPresenter {
    
    weak var view: PostsListViewInput?
    weak var output: PostsListModuleOutput?
    private let router: PostsListRouterInput
    private let interactor: PostsListInteractorInput
    private let stringFactory: PostsListStringFactoryProtocol
    private let alertManager: AlertManagerProtocol
    private let frameCalculator: FrameCalculatorProtocol
    private let accountID: String
    private let context: InputFlowContext
    private var viewModels: [PostCellViewModel]
    private var allowedNextPosts: Bool
    
    init(router: PostsListRouterInput,
         interactor: PostsListInteractorInput,
         alertManager: AlertManagerProtocol,
         stringFactory: PostsListStringFactoryProtocol,
         frameCalculator: FrameCalculatorProtocol,
         context: InputFlowContext,
         accountID: String) {
        self.router = router
        self.stringFactory = stringFactory
        self.interactor = interactor
        self.context = context
        self.alertManager = alertManager
        self.frameCalculator = frameCalculator
        self.accountID = accountID
        self.viewModels = []
        self.allowedNextPosts = false
    }
}

extension PostsListPresenter: PostsListViewOutput {

    func reveal(at indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.row]
        viewModel.showedFullText = true
        view?.reloadData(post: viewModel)
    }
    
    func likePost(at indexPath: IndexPath) {
        let post = viewModels[indexPath.row]
        if post.likedByMe {
            guard let index = post.likersIds.firstIndex(of: accountID) else { return }
            post.likersIds.remove(at: index)
            interactor.unlike(postID: post.id, ownerID: post.userID)
        } else {
            post.likersIds.append(accountID)
            interactor.like(postID: post.id, ownerID: post.userID)
        }
        post.likedByMe.toggle()
    }
    
    func presentMenu(at indexPath: IndexPath) {
        router.openMenuAlert(preserved: indexPath)
    }
    
    func openUserProfile(at indexPath: IndexPath) {
        guard case .allPosts = context else { return }
        let model = post(at: indexPath)
        guard model.owner.id != accountID else { return }
        router.openUserProfile(model.owner)
    }
    
    var postsTitleHeight: CGFloat {
        switch context {
        case .user:
            return Constants.zero
        case .allPosts, .currentUser:
            return Constants.titleViewHeight
        }
    }
    
    var infoTitleHeight: CGFloat {
        viewModels.isEmpty ? Constants.infoTitleHeight : Constants.zero
    }

    var title: String {
        switch context {
        case .user:
            return stringFactory.userPostsTitle
        case .currentUser:
            return stringFactory.currentUserPostsTitle
        case .allPosts:
            return stringFactory.allPostsTitle
        }
    }
    
    var createPostTitle: String {
        stringFactory.createPostTitle
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
        view?.setLoad(on: true)
        requestPosts()
    }
    
    func viewWillAppear() {
        PostCellConstants.topBarHeight = view?.topBarHeight
        PostCellConstants.bottonBarHeight = view?.buttonBarHeight
    }
    
    func post(at indexPath: IndexPath) -> PostCellViewModelProtocol {
        viewModels[indexPath.row]
    }
    
    func rowHeight(at indexPath: IndexPath) -> CGFloat {
        viewModels[indexPath.row].height
    }
    
    func requestPosts() {
        switch context {
        case .allPosts:
            interactor.requestFirstPosts()
        case .user(let id), .currentUser(let id):
            interactor.requestFirstPosts(userID: id)
        }
    }
    
    func requestMorePosts() {
        guard allowedNextPosts,
              viewModels.count >= PostsManager.Limits.posts.rawValue else { return }
        view?.setFooterLoad(on: true)
        allowedNextPosts = false
        switch context {
        case .allPosts:
            interactor.requestNextPosts()
        case .user(let id), .currentUser(let id):
            interactor.requestNextPosts(userID: id)
        }
    }
}

extension PostsListPresenter: ListsHeaderTitleViewOutput {
    func mainButtonAction() {
        switch context {
        case .allPosts, .currentUser:
            router.openPostCreationModule(output: self)
        case .user:
            break
        }
    }
}

extension PostsListPresenter: PostCreateModuleOutput {
    func updatePostList() {
        requestPosts()
    }
}

extension PostsListPresenter: PostsListRouterOutput {
    func delete(preserved: IndexPath) {
        let model = viewModels.remove(at: preserved.row)
        interactor.deletePost(postID: model.id)
        view?.reloadData(with: model)
    }
}

extension PostsListPresenter: PostsListInteractorOutput {

    func successLoadedAllFirstPosts(_ posts: [PostModelProtocol]) {
        handlePosts(models: posts) { [weak self] cellViewModels in
            guard let self = self else { return }
            self.viewModels = cellViewModels
            self.view?.setLoad(on: false)
            self.view?.reloadData(posts: self.viewModels)
            self.allowedNextPosts = true
        }
    }
    
    func successLoadedAllNextPosts(_ posts: [PostModelProtocol]) {
        handlePosts(models: posts) { [weak self] cellViewModels in
            guard let self = self else { return }
            self.viewModels.append(contentsOf: cellViewModels)
            self.view?.setFooterLoad(on: false)
            self.view?.reloadData(posts: self.viewModels)
            self.allowedNextPosts = !cellViewModels.isEmpty
        }
    }
    
    func successLoadedUserFirstPosts(_ posts: [PostModelProtocol]) {
        handlePosts(models: posts) { [weak self] cellViewModels in
            guard let self = self else { return }
            self.viewModels = cellViewModels
            self.view?.setLoad(on: false)
            self.view?.reloadData(posts: self.viewModels)
            self.allowedNextPosts = true
        }
    }
    
    func successLoadedUserNextPosts(_ posts: [PostModelProtocol]) {
        handlePosts(models: posts) { [weak self] cellViewModels in
            guard let self = self else { return }
            self.viewModels.append(contentsOf: cellViewModels)
            self.view?.setFooterLoad(on: false)
            self.view?.reloadData(posts: self.viewModels)
            self.allowedNextPosts = !cellViewModels.isEmpty
        }
    }
    
    func failureLoadAllFirstPosts(message: String) {
        view?.setLoad(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func failureLoadAllNextPosts(message: String) {
        view?.setFooterLoad(on: false)
        alertManager.present(type: .error, title: message)
        self.allowedNextPosts = true
    }
    
    func failureLoadUserFirstPosts(message: String) {
        view?.setLoad(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func failureLoadUserNextPosts(message: String) {
        view?.setFooterLoad(on: false)
        alertManager.present(type: .error, title: message)
        self.allowedNextPosts = true
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
    func handlePosts(models: [PostModelProtocol],
                     completion: @escaping ([PostCellViewModel]) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let viewModels: [PostCellViewModel] = models.map {
                let cellViewModel = PostCellViewModel(model: $0, owner: $0.owner)
                let frames = self.frameCalculator.calculate(model: cellViewModel)
                cellViewModel.frames = frames.visibleFrame
                cellViewModel.realFrames = frames.realFrame
                return cellViewModel
            }
            completion(viewModels)
        }
    }
}
