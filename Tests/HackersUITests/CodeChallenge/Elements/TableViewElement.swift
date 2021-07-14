//
//  TableViewElement.swift
//  Hackers
//
//  Created by Dmitrii Vokuev on 13.07.21.
//  Copyright © 2021 Glass Umbrella. All rights reserved.
//

import Foundation
import XCTest

class TableViewElement: XCTestCase {
    // POST cell ids
    let imageLocator  = "thumbnailImageViewID"
    let titleLocator = "titleLabelID"
    let metadaLocator = "metaDataLabelID"
    // Comment cell ids
    let commentText = "commentsID"
    let authorLabel = "authorLabelID"
    let datePostedLabel = "datePostedLabelID"
    let upvoteIconImageView = "upvoteIconImageViewID"
    // SortView ids
    let cvSortLocator = "sortCollectionViewID"

    func tapFirstCell() {
        XCTContext.runActivity(named: "Tap on the first cell") {_ in
            let waitResult = waitForElementToAppear(XCUIApplication().cells.firstMatch)
            if waitResult {
                XCUIApplication().cells.firstMatch.tap()
            } else {
                XCTFail("No cell found")
            }
        }
    }

    func tapByCellNumber(cellNum: Int?) {
        guard let cellNumGuard = cellNum else {
            XCTFail("No cell number passed as parameter")
            return
        }
        XCTContext.runActivity(named: "Tap on the first cell") {_ in
            let cell = XCUIApplication().cells.element(boundBy: cellNumGuard)
            let waitResult = waitForElementToAppear(cell)
            if waitResult {
                cell.tap()
            } else {
                XCTFail("No cell found")
            }
        }
    }
    
    func postCellCheck(cellNum: Int?) {
        guard let gCellNum = cellNum else {
            XCTFail("No cell number passed as parameter")
            return
        }
        XCTContext.runActivity(named: "Tap on the first cell") {_ in
            let waitResult = waitForElementToAppear(XCUIApplication().staticTexts[titleLocator])
            if waitResult {
                let imageEl = XCUIApplication().cells.element(boundBy: gCellNum).images[imageLocator].isEnabled
                let titleEl = XCUIApplication().cells.element(boundBy: gCellNum).staticTexts[titleLocator].isEnabled
                let metadataEl = XCUIApplication().cells.element(boundBy: gCellNum).staticTexts[metadaLocator].isEnabled
                XCTAssert(imageEl)
                XCTAssert(titleEl)
                XCTAssert(metadataEl)
            }
        }
    }
    func commentCellCheck(cellNum: Int?) {
        guard let gCellNum = cellNum else {
            XCTFail("No cell number passed as parameter")
            return
        }
        XCTContext.runActivity(named: "Tap on the first cell") {_ in
            let waitResult = waitForElementToAppear(XCUIApplication().staticTexts[commentText])
            if waitResult {
            let commentEl = XCUIApplication().cells.element(boundBy: gCellNum).staticTexts[commentText].isEnabled
            let authorLabelEl = XCUIApplication().cells.element(boundBy: gCellNum).staticTexts[authorLabel].isEnabled
            let datePostedEl = XCUIApplication().cells.element(boundBy: gCellNum).staticTexts[datePostedLabel].isEnabled
            //        let upvoteIconImageViewElement = XCUIApplication().cells.element(boundBy: cellNumGuard).images[upvoteIconImageView].isEnabled
            XCTAssert(commentEl)
            XCTAssert(authorLabelEl)
            XCTAssert(datePostedEl)
            //        XCTAssert(upvoteIconImageViewElement)
            }
        }
    }
    func commentCellCollapsedCheck(cellNum: Int?) {
        guard let gCellNum = cellNum else {
            XCTFail("No cell number passed as parameter")
            return
        }
        XCTContext.runActivity(named: "Tap on the first cell") {_ in
            let waitResult = waitForElementToAppear(XCUIApplication().staticTexts[commentText])
            if waitResult {
            let commentEl = XCUIApplication().cells.element(boundBy: gCellNum).staticTexts[commentText].isEnabled
            let authorLabelEl = XCUIApplication().cells.element(boundBy: gCellNum).staticTexts[authorLabel].isEnabled
            let datePostedEl = XCUIApplication().cells.element(boundBy: gCellNum).staticTexts[datePostedLabel].isEnabled
            XCTAssert(commentEl)
            XCTAssertFalse(commentEl)
            XCTAssert(authorLabelEl)
            XCTAssert(datePostedEl)
            }
        }
    }
    func sortCellTap(cellName: SortViewEnum?) {
        guard let gCellName = cellName else {
            XCTFail("No sort cell passed as parameter")
            return
        }
        XCTContext.runActivity(named: "Tap on the sort cell \(gCellName.rawValue)") {_ in
            let predicate = NSPredicate(format: "label BEGINSWITH[cd] '\(gCellName.rawValue)'")
            let button = XCUIApplication().buttons.element(matching: predicate)
            let waitResult = waitForElementToAppear(button)
            print(waitResult)
            print(gCellName.rawValue)
            if waitResult {
                button.tap()
            }
        }
    }

}
