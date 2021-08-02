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
                XCTAssert(imageEl)
                XCTAssert(titleEl)
            }
        }
    }
    func postMockCellCheck() {
        let mockWebServer = MockWebServerService()
        var mockData = [MainCellStructAssert]()
        let expectation = XCTestExpectation(description: "wait mock")
        _ = mockWebServer.parameters { datas in
            for (index, data) in datas.enumerated() {
                let urlString = (data as? Post)?.url
                let domain = urlString?.host
                let comments = (data as? Post)?.commentsCount
                let age = (data as? Post)?.age
                let by = (data as? Post)?.by
                let score = (data as? Post)?.score
                let title = (data as? Post)?.title
                guard let guardScore = score, let guardComments = comments, let guardDomain = domain else {
                    return
                }
                let metaData = "\(guardScore) \(guardComments) \(guardDomain)"
                mockData.append(MainCellStructAssert(index: index, title: title, age: age, by: by, metaData: metaData))
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
        assertMockCell(metaData: mockData)
    }
    func assertMockCell(metaData: [MainCellStructAssert]) {
        for data in metaData {
            let elementsTitle = XCUIApplication().staticTexts[data.title!].isEnabled
            let elementsText = XCUIApplication().staticTexts[data.metaData!].isEnabled
            XCTAssertTrue(elementsTitle)
            XCTAssertTrue(elementsText)

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
                XCTAssert(commentEl)
                XCTAssert(authorLabelEl)
                XCTAssert(datePostedEl)
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
