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
    private let context: InputFlowContext
    private var posts: [PostCellViewModel]
    
    init(router: PostsListRouterInput,
         interactor: PostsListInteractorInput,
         context: InputFlowContext) {
        self.router = router
        self.interactor = interactor
        self.context = context
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
        view?.setLoad(on: true)
        requestPosts()
    }
    
    func post(at indexPath: IndexPath) -> PostCellViewModel {
        posts[indexPath.row]
    }
    
    func rowHeight(at indexPath: IndexPath) -> CGFloat {
        posts[indexPath.row].frame.height
    }
    
    func requestPosts() {
        switch context {
        case .allPosts:
            interactor.requestFirstPosts()
        case .user(let id, _), .currentUser(let id):
            interactor.requestFirstPosts(userID: id)
        }
    }
    
    func requestMorePosts() {
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
    
}

extension PostsListPresenter: PostsListModuleInput {
    
}

private extension PostsListPresenter {
    struct Constants {
        static let zero: CGFloat = 0
        static let infoTitleHeight: CGFloat = 250
        static let titleViewHeight: CGFloat = 60
    }
}
