//
//  File.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//

import Foundation
import UIKit
import Managers
import DesignSystem

struct Frames {
    var textContentFrame: CGRect
    var postImageFrame: CGRect
    var buttonFrame: CGRect
    var height: CGFloat
}

protocol FrameCalculated: AnyObject {
    var realFrames: Frames? { get set }
    var frames: Frames? { get set }
    var imageSize: CGSize? { get }
    var textContent: String { get }
}

protocol FrameCalculatorProtocol {
    func calculate(model: FrameCalculated) -> (visibleFrame: Frames, realFrame: Frames?)
}

struct FrameCalculator: FrameCalculatorProtocol {
    
    func calculate(model: FrameCalculated) -> (visibleFrame: Frames, realFrame: Frames?) {
        let textHeightAndButtonFrame = getTextHeightWithButtonFrame(model: model)
        let textHeight = textHeightAndButtonFrame.0
        let buttonFrame = textHeightAndButtonFrame.1
        
        let textContentFrame = CGRect(x: PostCellConstants.contentInset, y: PostCellConstants.heightTopView, width: PostCellConstants.textWidth, height: textHeight)
        
        let postImageSize = getPostImageSize(from: model.imageSize, textHeight: textHeight, buttonHeight: buttonFrame.height)
        let postImageOriginX = getPostImageOriginX(from: postImageSize)
        let postImageOriginY = getPostImageOriginY(textHeight: textHeight, buttonHeight: buttonFrame.height)
        let postImageFrame = CGRect(x: postImageOriginX, y: postImageOriginY, width: postImageSize.width, height: postImageSize.height)
        
        let postHeight = PostCellConstants.heightTopView + textHeight + postImageSize.height + PostCellConstants.cardViewBottonInset + buttonFrame.height + PostCellConstants.heightButtonView
        let frames = Frames(textContentFrame: textContentFrame, postImageFrame: postImageFrame, buttonFrame: buttonFrame, height: postHeight)
        var realFrames: Frames?
        if buttonFrame != .zero {
            let realTextHeight = model.textContent.height(width: PostCellConstants.textWidth, font: PostCellConstants.postsTextFont)
            let realTextContentFrame = CGRect(x: PostCellConstants.contentInset, y: PostCellConstants.heightTopView, width: PostCellConstants.textWidth, height: realTextHeight)
            let realPostImageOriginY = getPostImageOriginY(textHeight: realTextHeight, buttonHeight: 0)
            let realPostImageFrame = CGRect(x: postImageOriginX, y: realPostImageOriginY, width: postImageSize.width, height: postImageSize.height)
            let realPostHeight = PostCellConstants.heightTopView + realTextHeight + postImageSize.height + PostCellConstants.cardViewBottonInset + PostCellConstants.heightButtonView
            realFrames = Frames(textContentFrame: realTextContentFrame, postImageFrame: realPostImageFrame, buttonFrame: .zero, height: realPostHeight)
        }
        return (frames, realFrames)
    }
}

private extension FrameCalculator {
    func getTextHeightWithButtonFrame(model: FrameCalculated) -> (CGFloat,CGRect) {
        if model.textContent == "" {
            return (0,.zero)
        }
        let height = model.textContent.height(width: PostCellConstants.textWidth, font: PostCellConstants.postsTextFont)
        if height > PostCellConstants.maxTextHeight {
            let y = PostCellConstants.heightTopView + PostCellConstants.maxTextHeight
            return (PostCellConstants.maxTextHeight,CGRect(x: PostCellConstants.contentInset, y: y, width: PostCellConstants.buttonWidth, height: PostCellConstants.buttonFont.lineHeight))
        }
        return (height,.zero)
    }
    
    
    func getPostImageSize(from size: CGSize?, textHeight: CGFloat, buttonHeight: CGFloat) -> CGSize {
        let size = calculateFirstImageSize(from: size)
        let totalHeight = PostCellConstants.totalHeight - textHeight - buttonHeight
        if size.height > totalHeight  {
            let height = totalHeight
            let ratio = size.height/height
            let width = size.width/ratio
            return CGSize(width: width, height: height)
        } else {
            return size
        }
    }
    
    func calculateFirstImageSize(from size: CGSize?) -> CGSize {
        guard let size = size else { return .zero }
        if size.width > UIScreen.main.bounds.width - 2*PostCellConstants.cardViewSideInset {
            let width = UIScreen.main.bounds.width - 2*PostCellConstants.cardViewSideInset
            let ratio = size.width / width
            let height = size.height / ratio
            return CGSize(width: width, height: height)
        } else {
            return size
        }
    }
    
    func getPostImageOriginX(from size: CGSize) -> CGFloat {
        if size.width < UIScreen.main.bounds.width - 2*PostCellConstants.cardViewSideInset {
            return (UIScreen.main.bounds.width - size.width - 2*PostCellConstants.cardViewSideInset)/2
        } else {
            return 0
        }
    }
    
    func getPostImageOriginY(textHeight: CGFloat, buttonHeight: CGFloat) -> CGFloat {
        return PostCellConstants.heightTopView + textHeight + buttonHeight + PostCellConstants.imageAndTextInset
    }
}
