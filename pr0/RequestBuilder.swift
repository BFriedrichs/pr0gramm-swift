//
//  RequestBuilder.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 07.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class RequestBuilder {
  static func buildRequest(withUrl url: URL, method: String = "GET") -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.httpShouldHandleCookies = true
    
    request.setValue(Constants.getUserAgent(), forHTTPHeaderField: "User-Agent")
    request.setValue("de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4,sk;q=0.2", forHTTPHeaderField: "Accept-Language")
    request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
    request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.setValue("pr0gramm.com", forHTTPHeaderField: "Host")
    request.setValue("https://pr0gramm.com", forHTTPHeaderField: "Origin")
    request.setValue("https://pr0gramm.com", forHTTPHeaderField: "Referer")
    request.setValue("no-cache", forHTTPHeaderField: "Pragma")
    request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
    
    return request
  }
}
