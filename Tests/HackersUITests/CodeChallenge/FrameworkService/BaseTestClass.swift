//
//  BaseTestClass.swift
//  HackersUITests
//
//  Created by Dmitrii Vokuev on 14.07.21.
//  Copyright © 2021 Glass Umbrella. All rights reserved.
//

import Foundation
import XCTest

class BaseTestClass: XCTestCase {
    let app = XCUIApplication()
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    override func setUpWithError() throws {
        super.setUp()
        setupSnapshot(app, waitForAnimations: false)
        app.launchArguments = [
            "disableReviewPrompts",
            "skipAnimations",
            "disableOnboarding"
        ]
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        deleteMyApp()
    }

    func deleteMyApp() {
        app.terminate()
        let bundleDisplayName = "Hackers"
        let icon = springboard.icons[bundleDisplayName]
        if icon.exists {
            icon.press(forDuration: 1)

            let buttonRemoveApp = springboard.buttons["Remove App"]
            if buttonRemoveApp.waitForExistence(timeout: 5) {
                buttonRemoveApp.tap()
            } else {
                XCTFail("Button \"Remove App\" not found")
            }

            let buttonDeleteApp = springboard.alerts.buttons["Delete App"]
            if buttonDeleteApp.waitForExistence(timeout: 5) {
                buttonDeleteApp.tap()
            } else {
                XCTFail("Button \"Delete App\" not found")
            }

            let buttonDelete = springboard.alerts.buttons["Delete"]
            if buttonDelete.waitForExistence(timeout: 5) {
                buttonDelete.tap()
            } else {
                XCTFail("Button \"Delete\" not found")
            }
        }
    }
}
