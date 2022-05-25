//
//  File.swift
//  
//
//  Created by Арман Чархчян on 03.05.2022.
//

import UIKit
import DesignSystem

struct PostCellConstants {
    static let zero: CGFloat  = 0
    static let userImageHeight: CGFloat = 47
    static let cardViewBottonInset: CGFloat = 11
    static let cardViewSideInset : CGFloat = 12
    static let heightTopView: CGFloat = 63
    static let postsTextFont: UIFont = UIFont.systemFont(ofSize: 15)
    static let buttonFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let contentInset : CGFloat = 11
    static var topBarHeight: CGFloat?
    static var bottonBarHeight: CGFloat?
    static let titleViewHeight: CGFloat = 60
    static let menuButtonHeight: CGFloat = 22
    static let imageAndTextInset: CGFloat = 4
    static let heightButtonView: CGFloat = 43
    static let maxLines: Int = 5
    static let buttonTitle: String = "показать полностью..."
    static let buttonWidth = buttonTitle.width(font: buttonFont)
    
    static var totalHeight: CGFloat {
        return UIScreen.main.bounds.height - heightButtonView - heightTopView - titleViewHeight - imageAndTextInset - cardViewBottonInset - (bottonBarHeight ?? 0) - (topBarHeight ?? 0)
    }
    
    static var maxTextHeight: CGFloat {
        return CGFloat(maxLines) * postsTextFont.lineHeight
    }
    
    static var textWidth: CGFloat {
        return UIScreen.main.bounds.width - 2*cardViewSideInset - 2*contentInset
    }
}
