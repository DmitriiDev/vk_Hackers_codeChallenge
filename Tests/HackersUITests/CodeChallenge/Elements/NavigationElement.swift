//
//  NavigationElement.swift
//  HackersUITests
//
//  Created by Dmitrii Vokuev on 13.07.21.
//  Copyright © 2021 Glass Umbrella. All rights reserved.
//

import Foundation
import XCTest

class NavigationElement: XCTestCase {
    let sortBtnLocator = "TitleButtonID"
    func backButton() {
        XCTContext.runActivity(named: "Back button tap") {_ in
            let rightNavBtn = XCUIApplication().navigationBars.children(matching: .button).firstMatch
            let waitResult = waitForElementToAppear(rightNavBtn)
            if waitResult {
                rightNavBtn.tap()
            } else {
                XCTFail("No back button found")
            }
        }
    }
    func sortButtonTap() {
        XCTContext.runActivity(named: "Sort button tap") {_ in
            let sortBtn = XCUIApplication().navigationBars.buttons[sortBtnLocator]
            let waitResult = waitForElementToAppear(sortBtn)
            if waitResult {
                sortBtn.tap()
            } else {
                XCTFail("No back button found")
            }
        }

    }
    func sortButtonVerify(sortName: SortViewEnum?) {
        guard let gSortName = sortName else {
            XCTFail("No sort name passed as parameter")
            return
        }
        XCTContext.runActivity(named: "Sort button tap") {_ in
            let predicate = NSPredicate(format: "identifier BEGINSWITH[cd] '\(gSortName.rawValue)'")
            let button = XCUIApplication().navigationBars.element(matching: predicate)
            let waitResult = waitForElementToAppear(button)
            XCTAssertTrue(waitResult)
        }
    }
    func closeWebView() {
        XCTContext.runActivity(named: "Sort button tap") {_ in
            wait(for: 2)
            let predicate = NSPredicate(format: "label BEGINSWITH[cd] 'Done'")
            let button = XCUIApplication().buttons.element(matching: predicate)
            print("=============")
            print(button.debugDescription)
            print(XCUIApplication().debugDescription)
            print("=============")
            let waitResult = waitForElementToAppear(button)
            if waitResult {
                button.tap()
            } else {
                XCTFail("No done button found")
            }
            XCTAssertTrue(waitResult)
        }

    }
}
