//
//  HackersKit.swift
//  Hackers
//
//  Created by Weiran Zhang on 11/05/2020.
//  Copyright © 2020 Weiran Zhang. All rights reserved.
//

import Foundation
import PromiseKit

class HackersKit {
    static let shared = HackersKit()

    let session = URLSession(configuration: .default)
    let scraperShim = HNScraperShim()

    weak var authenticationDelegate: HackerNewsAuthenticationDelegate?

    init() {
        scraperShim.authenticationDelegate = self
    }

    internal func fetchHtml(url: URL) -> Promise<String> {
        let (promise, seal) = Promise<String>.pending()
        if ProcessInfo.processInfo.arguments.contains("mockWebServer") {
            fetchData(userCompletionHandler: { data, error in
                if data != nil {
                    let html = String(bytes: data!, encoding: .utf8)
                     seal.fulfill(html!)
                }
                if error != nil {
                    print("No Data!")
                }
            })
        } else {
            session.dataTask(with: url) { data, _, error in
                if let data = data, let html = String(bytes: data, encoding: .utf8) {
                    seal.fulfill(html)
                } else if let error = error {
                    seal.reject(error)
                } else {
                    seal.reject(HackersKitError.requestFailure)
                }
            }.resume()
        }

        return promise
    }

    private func fetchData(userCompletionHandler: @escaping (Data?, Error?) -> Void) {
      let url = URL(string: "http://localhost:9090/responses/htmlHackerResp.html")!
      let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 999, userInfo: nil)
            _ = userCompletionHandler(nil, error)
            return
        }
        guard let dataGuard = data else {
            return
        }
        do {
            _ = userCompletionHandler(dataGuard, nil)
        }
      })
      task.resume()
    }
}
