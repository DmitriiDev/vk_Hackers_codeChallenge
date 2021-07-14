//
//  AuthenticationUIService.swift
//  Hackers
//
//  Created by Weiran Zhang on 27/05/2019.
//  Copyright © 2019 Weiran Zhang. All rights reserved.
//

import BLTNBoard
import PromiseKit

class AuthenticationUIService {
    private let sessionService: SessionService

    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }

    var bulletinManager: BLTNItemManager?

    func showAuthentication() {
        let manager = BLTNItemManager(rootItem: loginPage())
        manager.backgroundColor = AppTheme.default.backgroundColor
        manager.backgroundViewStyle = .blurredDark
        bulletinManager = manager
        bulletinManager?.showBulletin(in: UIApplication.shared)
    }

    private func displayActivityIndicator() {
        guard let bulletinManager = self.bulletinManager else { return }
        bulletinManager.displayActivityIndicator(color: AppTheme.default.textColor)
    }

    private func loginPage() -> AuthenticationBulletinPage {
        let page = AuthenticationBulletinPage(title: "Login")
        page.descriptionText = "Hackers never stores your password."
        page.actionButtonTitle = "Login"
        if sessionService.authenticationState == .authenticated {
            page.alternativeButtonTitle = "Logout"
        }
        page.isDismissable = true

        page.actionHandler = { item in
            guard let item = item as? AuthenticationBulletinPage else { return }

            if item.usernameTextField.text!.isEmpty || item.passwordTextField.text!.isEmpty {
                item.set(state: .invalid)
            } else {
                self.displayActivityIndicator()

                self.sessionService.authenticate(username: item.usernameTextField.text!,
                                                 password: item.passwordTextField.text!)
                .done { _ in
                    page.next = self.loginSuccessPage()
                    item.manager?.displayNextItem()
                }.ensure {
                    self.sendAuthenticationDidChangeNotification()
                }.catch { _ in
                    item.set(state: .invalid)
                    self.bulletinManager?.hideActivityIndicator()
                }
            }
        }

        page.alternativeHandler = { item in
            HackersKit.shared.logout()
            self.sendAuthenticationDidChangeNotification()
            item.manager?.dismissBulletin()
        }

        themeAppearance(of: page)

        return page
    }

    private func loginSuccessPage() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Logged In")
        let username = sessionService.username!
        page.descriptionText = "Successfully logged in as \(username)"
        page.image = UIImage(named: "SuccessIcon")?.withRenderingMode(.alwaysTemplate)
        page.appearance.imageViewTintColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        page.isDismissable = true
        page.actionButtonTitle = "Dismiss"
        page.actionHandler = { item in
            item.manager?.dismissBulletin()
        }
        themeAppearance(of: page)

        return page
    }

    private func themeAppearance(of item: BLTNPageItem) {
        item.appearance.actionButtonColor = AppTheme.default.appTintColor
        item.appearance.alternativeButtonTitleColor = AppTheme.default.appTintColor
        item.appearance.titleTextColor = AppTheme.default.titleTextColor
        item.appearance.descriptionTextColor = AppTheme.default.textColor
    }

    private func sendAuthenticationDidChangeNotification() {
        NotificationCenter.default.post(name: Notification.Name.refreshRequired, object: nil)
    }

    func unauthenticatedAlertController() -> UIAlertController {
        let unauthenticatedMessage = "You're not logged into Hacker News. Do you want to login now?"
        let authenticationAlert = UIAlertController(
            title: "Not logged in",
            message: unauthenticatedMessage,
            preferredStyle: .alert
        )
        authenticationAlert.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: nil))
        authenticationAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
            self.showAuthentication()
        }))
        return authenticationAlert
    }
}
