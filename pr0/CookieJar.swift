//
//  CookieJar.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 06.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

struct Pr0Cookie {
  let t: Int
  let n: String
  let id: String
  let a: Int
  let pp: Double
  let paid: Bool
  
  init(withData data: [String: Any]) {
    if let t = data["t"] {
      self.t = t as! Int
    } else {
      self.t = 0
    }

    self.n = data["n"] as! String
    self.id = data["id"] as! String
    self.a = data["a"] as! Int
    self.pp = data["pp"] as! Double
    self.paid = data["paid"] as! Bool
  }
}

class CookieJar {
  static let sharedInstance = CookieJar()
  
  var meCookie: Pr0Cookie?
  
  private init() {
    HTTPCookieStorage.shared.cookieAcceptPolicy = .always
    _ = getMeCookie()
  }
  
  func clearCookies() {
    HTTPCookieStorage.shared.removeCookies(since: Date().addingTimeInterval(-50000))
    self.meCookie = nil
  }
  
  func getMeCookie() -> Pr0Cookie? {
    let cookies = HTTPCookieStorage.shared.cookies
    for cookie in cookies! {
      if cookie.name == "me" {
        let val = cookie.value
        let decoded = val.removingPercentEncoding
        do {
          let parsed = try JSONSerialization.jsonObject(with: decoded!.data(using: .utf8)!)
          let cookie = Pr0Cookie(withData: parsed as! [String: Any])
          self.meCookie = cookie
          return self.meCookie
        }
        catch {
          
        }
      }
    }
    return nil
  }
}
