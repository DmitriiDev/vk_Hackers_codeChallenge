//
//  Models.swift
//  Hackers
//
//  Created by Dmitrii Vokuev on 12.07.21.
//  Copyright © 2021 Glass Umbrella. All rights reserved.
//

import Foundation

struct Test_models {
    enum Navigation {
        case backButton
        case tapFirstCell
        case tapCellNumber
        case tapSortViewCell
        case closeWebView
        case openSortingView
    }
    enum Actions {
        case appToForeground
        case appToBackGround
        case deleteTheApp
        case scrollUp
        case scrollDown
        case swipeRight
        case swipeLeft
    }
    enum Elements {
        case findElementById(String)
        case findElement(XCElements)
        case getLabelText
        case sendTextToTextField
    }
    enum Checks {
        case checkPostCell
        case checkCommentCell
        case checkCommentCollapsedCell
        case sortBtnVerify
        case checkMockPostCell
    }
}

enum XCElements {
    case tableViews
    case cells
    case labels
    case buttons
}
