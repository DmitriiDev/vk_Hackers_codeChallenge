//
//  MockWebServerService.swift
//  HackersUITests
//
//  Created by Dmitrii Vokuev on 30.07.21.
//  Copyright © 2021 Glass Umbrella. All rights reserved.
//

import Foundation

class MockWebServerService {
    
private func fetchData(completionHandler: @escaping (Data?, Error?) -> Void) {
  let url = URL(string: "http://localhost:9090/responses/htmlHackerResp.html")!
  let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 999, userInfo: nil)
        _ = completionHandler(nil, error)
        return
    }
    guard let dataGuard = data else {
        return
    }
    do {
        _ = completionHandler(dataGuard, nil)
    }
  })
  task.resume()
}

    func parameters(completionHandler: @escaping ([Any]) -> Void)  {
        var html: String = ""
        fetchData(completionHandler: { data, error in
            if data != nil {
                html = String(bytes: data!, encoding: .utf8) ?? ""
                do {
                   let elements = try HtmlParser.postsTableElement(from: html)
                   let posts = try HtmlParser.posts(from: elements, type: .best)
                   _ = completionHandler(posts)
                } catch {
                    print("Error")
                }
            }
            if error != nil {
                print("No Data!")
            }
        })
    }
}
