//
//  Interactor.swift
//  Hackers
//
//  Created by Dmitrii Vokuev on 13.07.21.
//  Copyright © 2021 Glass Umbrella. All rights reserved.
//

import Foundation
import XCTest

class Interactor: XCTestCase {
    private let baseClass = BaseTestClass()
    private let table = TableViewElement()
    private let label = LabelElement()
    private let button = ButtonElement()
    private let navigation = NavigationElement()
    private let app = XCUIApplication()

    func taskNavigation(todo: Test_models.Navigation, _ cellNum: Int? = 1, sortCell: SortViewEnum? = .top) {
        switch todo {
        case .backButton:
            navigation.backButton()
        case .tapFirstCell:
            table.tapFirstCell()
        case .tapCellNumber:
            table.tapByCellNumber(cellNum: cellNum)
        case .openSortingView:
            navigation.sortButtonTap()
        case .tapSortViewCell:
            table.sortCellTap(cellName: sortCell)
        case .closeWebView:
            navigation.closeWebView()
        }
    }

    func taskAssert(todo: Test_models.Checks, _ cellNum: Int? = 1, sortBtnName: SortViewEnum? = .top) {
        switch todo {
        case .checkCommentCell:
            table.commentCellCheck(cellNum: cellNum)
        case .checkPostCell:
            table.postCellCheck(cellNum: cellNum)
        case .checkCommentCollapsedCell:
            table.commentCellCollapsedCheck(cellNum: cellNum)
        case .sortBtnVerify:
            navigation.sortButtonVerify(sortName: sortBtnName)
        }
    }
    
    func taskAction(todo: Test_models.Actions) {
        switch todo {
        case .appToForeground:
            app.activate()
        case .appToBackGround:
            XCUIDevice.shared.press(XCUIDevice.Button.home)
        case .deleteTheApp:
            baseClass.deleteMyApp()
        case .scrollUp:
            app.swipeUp()
        case .scrollDown:
            app.swipeDown()
        case .swipeRight:
            app.swipeRight()
        case .swipeLeft:
            app.swipeLeft()
        }
    }

}
