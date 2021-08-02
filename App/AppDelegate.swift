//
//  AppDelegate.swift
//  Hackers
//
//  Created by Weiran Zhang on 07/06/2014.
//  Copyright (c) 2014 Weiran Zhang. All rights reserved.
//

import UIKit
import SwinjectStoryboard
import GCDWebServer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationService: NavigationService?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        // process args for testing
        if ProcessInfo.processInfo.arguments.contains("disableReviewPrompts") {
            ReviewController.disablePrompts = true
        }
        if ProcessInfo.processInfo.arguments.contains("skipAnimations") {
            UIView.setAnimationsEnabled(false)
        }
        if ProcessInfo.processInfo.arguments.contains("mockWebServer") {
            launchWebServer()
        }
        if ProcessInfo.processInfo.arguments.contains("mockWebServer") {
            launchWebServer()
        }
        // setup window and entry point
        window = UIWindow()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let mainSplitViewController = storyboard.instantiateViewController(
            identifier: "MainSplitViewController"
        ) as MainSplitViewController
        window?.rootViewController = mainSplitViewController
        window?.tintColor = AppTheme.default.appTintColor
        window?.makeKeyAndVisible()

        if ProcessInfo.processInfo.arguments.contains("darkMode") {
            window?.overrideUserInterfaceStyle = .dark
        }

        // setup NavigationService
        navigationService = SwinjectStoryboard.getService()
        navigationService?.mainSplitViewController = mainSplitViewController

        // setup review prompt
        ReviewController.incrementLaunchCounter()
        ReviewController.requestReview()

        // init default settings
        UserDefaults.standard.registerDefaults()
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        // handle incoming links to open post
        let bundleIdentifier = String(Bundle.main.bundleIdentifier!)
        if let scheme = url.scheme,
            scheme.localizedCaseInsensitiveCompare(bundleIdentifier) == .orderedSame,
            let view = url.host {
            let parameters = parseParameters(from: url)

            switch view {
            case "item":
                if let idString = parameters["id"],
                    let id = Int(idString) {
                    navigationService?.showPost(id: id)
                }
            default: break
            }
        }
        return true
    }

    private func parseParameters(from url: URL) -> [String: String] {
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        return parameters
    }
    
    private func launchWebServer() {
        let webServer = GCDWebServer()
        webServer.addGETHandler(forBasePath: "/responses/", directoryPath: Bundle.main.bundlePath + "/MockWebServer/responses", indexFilename: nil, cacheAge: 0, allowRangeRequests: true)
        do {
            try webServer.start(options: [GCDWebServerOption_AutomaticallySuspendInBackground: false, GCDWebServerOption_Port: 9090, "BindToLocalhost": true])
            print("mock web server has been launched")
        } catch {
        }
    }

}
