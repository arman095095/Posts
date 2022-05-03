//
//  File.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//

import Foundation
import UIKit
import Managers

protocol CellCalculatable: AnyObject {
    var realFrames: Frames? { get set }
    var frames: Frames? { get set }
    var imageSize: CGSize? { get }
    var textContent: String { get }
}

extension String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        return ceil(size.height)
    }
    
    func width(font:UIFont) -> CGFloat {
        let textSize = CGSize(width: .greatestFiniteMagnitude, height:font.lineHeight )
        
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        return ceil(size.width)
    }
    
}

protocol FrameCalculatorProtocol {
    func calculate(model: CellCalculatable) -> (visibleFrame: Frames, realFrame: Frames?)
}

struct PostCellConstants {
    static let zero: CGFloat  = 0
    static let userImageHeight: CGFloat = 47
    
    static let cardViewBottonInset: CGFloat = 11
    static let cardViewSideInset : CGFloat = 12
    
    static let heightTopView: CGFloat = 63
    
    static var postsTextFont: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    static var buttonFont: UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    static let contentInset : CGFloat = 11
    static var topBarHeight: CGFloat?
    static var bottonBarHeight: CGFloat?
    static let titleViewHeight: CGFloat = 60
    static let menuButtonHeight: CGFloat = 22
    
    static let imageAndTextInset: CGFloat = 4
    static let heightButtonView: CGFloat = 43
    
    static var totalHeight: CGFloat {
        return UIScreen.main.bounds.height - heightButtonView - heightTopView - titleViewHeight - imageAndTextInset - cardViewBottonInset - (bottonBarHeight ?? 0) - (topBarHeight ?? 0)
    }
    
    static var maxLines: Int {
        return 5
    }
    
    static var maxTextHeight: CGFloat {
        return CGFloat(maxLines) * postsTextFont.lineHeight
    }
    
    static var textWidth: CGFloat {
        return UIScreen.main.bounds.width - 2*cardViewSideInset - 2*contentInset
    }
    
    static let buttonWidth = "показать полностью...".width(font: buttonFont)
    
    static func setupCountableItemPresentation(countOf: Int?) -> String {
        guard let count = countOf else { return "" }
        if count == 0 { return "" }
        
        let countDouble = Double(count)
        if count > 999 && count < 1000000 {
            let str = String(format: "%.1f", countDouble/1000)
            if str.last != "0" {
                return String(format: "%.1f", countDouble/1000) + "K" }
            else {
                return "\(Int(countDouble/1000))" + "K"
            }
        }
        else if count >= 1000000 {
            let str = String(format: "%.1f", countDouble/1000000)
            if str.last != "0" {
                return String(format: "%.1f", countDouble/1000000) + "M" }
            else {
                return "\(Int(countDouble/1000000))" + "M"
            }
        } else {
            return "\(count)"
        }
    }
}

struct Frames {
    var textContentFrame: CGRect
    var postImageFrame: CGRect
    var buttonFrame: CGRect
    var height: CGFloat
}

struct FrameCalculator: FrameCalculatorProtocol {
    
    func calculate(model: CellCalculatable) -> (visibleFrame: Frames, realFrame: Frames?) {
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
    func getTextHeightWithButtonFrame(model: CellCalculatable) -> (CGFloat,CGRect) {
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
