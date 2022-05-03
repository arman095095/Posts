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

protocol PostCellViewModelProtocol {
    var userID: String { get }
    var likersIds: [String] { get }
    var date: String { get }
    var textContent: String { get }
    var id: String { get }
    var realFrames: Frames? { get }
    var frames: Frames? { get }
    var urlImage: URL? { get }
    var imageSize: CGSize? { get }
    var userName: String { get }
    var ownerImageUrl: URL? { get }
    var region: String { get }
    var removed: Bool { get }
    var online: Bool { get }
    var likedByMe: Bool { get }
    var ownerMe: Bool { get }
    var likesCount: String { get }
    var ownerMenuButtonWidth: CGFloat { get }
    var contentInset: CGFloat { get }
    var likesCountAfterLike: String { get }
    var textContentFrame: CGRect { get }
    var postImageFrame: CGRect { get }
    var height: CGFloat { get }
    var buttonFrame: CGRect { get }
}

final class PostCellViewModel: CellCalculatable {
    var userID: String
    var likersIds: [String]
    var date: String
    var textContent: String
    var id: String
    var realFrames: Frames?
    var frames: Frames?
    var urlImage: URL?
    var imageSize: CGSize?
    var userName: String
    var showedFullText: Bool
    var ownerImageUrl: URL?
    var region: String
    var removed: Bool
    var online: Bool
    var likedByMe: Bool
    var ownerMe: Bool
    
    init(model: PostModelProtocol) {
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
        self.date = DateFormatService().convertDate(from: model.date)
        self.userName = model.owner.userName
        self.ownerImageUrl = URL(string: model.owner.imageUrl)
        self.region = "\(model.owner.country), \(model.owner.city)"
        self.removed = model.owner.removed
        self.online = model.owner.online
        self.likedByMe = model.likedByMe
        self.ownerMe = model.ownerMe
        self.showedFullText = false
    }
}

extension PostCellViewModel: PostCellViewModelProtocol {
    var contentInset: CGFloat {
        frames?.postImageFrame.size == .zero ? -PostCellConstants.imageAndTextInset : PostCellConstants.zero
    }
    
    var ownerMenuButtonWidth: CGFloat {
        ownerMe ? PostCellConstants.menuButtonHeight : PostCellConstants.zero
    }
    
    var likesCount: String {
        return PostCellConstants.setupCountableItemPresentation(countOf: likersIds.count)
    }
    
    var likesCountAfterLike: String {
        let newLikesCount = likedByMe ? likersIds.count - 1 : likersIds.count + 1
        return PostCellConstants.setupCountableItemPresentation(countOf: newLikesCount)
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
