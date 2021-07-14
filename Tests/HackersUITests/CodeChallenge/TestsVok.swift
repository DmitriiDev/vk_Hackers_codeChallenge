//
//  TestsVok.swift
//  Hackers
//
//  Created by Dmitrii Vokuev on 12.07.21.
//  Copyright © 2021 Glass Umbrella. All rights reserved.
//

import Foundation
import XCTest

class TestVok: BaseTestClass {
    let interactor = Interactor()
    func test_cellCheckContent() {
        interactor.taskAssert(todo: .checkPostCell, 1)
        interactor.taskNavigation(todo: .tapCellNumber, 1)
        interactor.taskAssert(todo: .checkCommentCell, 1)
        interactor.taskNavigation(todo: .tapCellNumber, 1)
        interactor.taskAssert(todo: .checkCommentCollapsedCell, 1)
        interactor.taskNavigation(todo: .tapCellNumber, 1)
        interactor.taskAssert(todo: .checkCommentCell, 1)
        interactor.taskNavigation(todo: .backButton)
    }

    func test_articlesSort() {
        interactor.taskNavigation(todo: .openSortingView)
        interactor.taskNavigation(todo: .tapSortViewCell, sortCell: .best)
        interactor.taskAssert(todo: .sortBtnVerify, sortBtnName: .best)
        interactor.taskNavigation(todo: .openSortingView)
        interactor.taskNavigation(todo: .tapSortViewCell, sortCell: .show)
        interactor.taskAssert(todo: .sortBtnVerify, sortBtnName: .show)
        interactor.taskNavigation(todo: .openSortingView)
        interactor.taskNavigation(todo: .tapSortViewCell, sortCell: .ask)
        interactor.taskAssert(todo: .sortBtnVerify, sortBtnName: .ask)
    }

    func test_openArticle() {
        interactor.taskAssert(todo: .checkPostCell, 1)
        interactor.taskNavigation(todo: .tapFirstCell)
        interactor.taskNavigation(todo: .tapFirstCell)
        interactor.taskNavigation(todo: .closeWebView)
        interactor.taskAssert(todo: .checkPostCell)
    }
}
