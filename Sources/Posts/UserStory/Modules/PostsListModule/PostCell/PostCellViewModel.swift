//
//  File.swift
//  
//
//  Created by Арман Чархчян on 03.05.2022.
//

import Foundation
import Managers
import UIKit
import Utils
import ModelInterfaces

protocol PostCellViewModelProtocol: AnyObject {
    var date: String { get }
    var textContent: String { get }
    var frames: Frames? { get }
    var urlImage: URL? { get }
    var userName: String { get }
    var ownerImageUrl: URL? { get }
    var likedByMe: Bool { get }
    var likesCount: String { get }
    var contentInset: CGFloat { get }
    var likesCountAfterLike: String { get }
    var textContentFrame: CGRect { get }
    var postImageFrame: CGRect { get }
    var buttonFrame: CGRect { get }
    var height: CGFloat { get }
    var onlineIconShow: Bool { get }
    var menuButtonShow: Bool { get }
    var owner: ProfileModelProtocol { get }
}

final class PostCellViewModel {
    private let ownerMe: Bool
    var owner: ProfileModelProtocol
    let userID: String
    let textContent: String
    let id: String
    var likersIds: [String]
    var date: String
    var realFrames: Frames?
    var frames: Frames?
    var urlImage: URL?
    var imageSize: CGSize?
    var showedFullText: Bool
    var likedByMe: Bool
    
    init(model: PostModelProtocol, owner: ProfileModelProtocol) {
        if let urlImage = model.urlImage,
           let width = model.imageWidth,
           let height = model.imageHeight {
            self.imageSize = CGSize(width: width, height: height)
            self.urlImage = URL(string: urlImage)
        }
        self.id = model.id
        self.textContent = model.textContent
        self.likersIds = model.likersIds
        self.userID = model.userID
        self.owner = owner
        self.date = DateFormatService().convertDate(from: model.date)
        self.likedByMe = model.likedByMe
        self.ownerMe = model.ownerMe
        self.showedFullText = false
    }
}

extension PostCellViewModel: PostCellViewModelProtocol,
                             FrameCalculated {

    var menuButtonShow: Bool {
        return ownerMe
    }

    var userName: String {
        owner.removed ? RemovedProfileConstants.name.rawValue : owner.userName
    }
    
    var ownerImageUrl: URL? {
        owner.removed ? URL(string: RemovedProfileConstants.imageURL.rawValue) : URL(string: owner.imageUrl)
    }
    
    var onlineIconShow: Bool {
        owner.removed ? false : owner.online
    }
    
    
    var contentInset: CGFloat {
        frames?.postImageFrame.size == .zero ? -PostCellConstants.imageAndTextInset : PostCellConstants.zero
    }
    
    var likesCount: String {
        return NumberFormatter().countFormat(for: .likes, count: likersIds.count)
    }
    
    var likesCountAfterLike: String {
        let newLikesCount = likedByMe ? likersIds.count - 1 : likersIds.count + 1
        return NumberFormatter().countFormat(for: .likes, count: newLikesCount)
    }
    
    var textContentFrame: CGRect {
        if showedFullText { return realFrames?.textContentFrame ?? .zero }
        return frames?.textContentFrame ?? .zero
    }
    
    var postImageFrame: CGRect {
        showedFullText ? (realFrames?.postImageFrame ?? .zero) : (frames?.postImageFrame ?? .zero)
    }
    
    var height: CGFloat {
        showedFullText ? (realFrames?.height ?? .zero) : (frames?.height ?? .zero)
    }
    
    var buttonFrame: CGRect {
        showedFullText ? ( .zero ) : (frames?.buttonFrame ?? .zero)
    }
}

extension PostCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PostCellViewModel, rhs: PostCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
