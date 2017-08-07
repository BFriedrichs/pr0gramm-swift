//
//  UserService.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 06.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class UserService {
  
  let path = "user"
  
  let userConnection: Connection
  let jar: CookieJar
  
  var isLoggedIn: Bool {
    return jar.meCookie != nil
  }
  
  var username: String {
    if isLoggedIn {
    	return jar.meCookie!.n
    }
    return ""
  }
  
  init() {
    self.jar = CookieJar.sharedInstance
    self.userConnection = Connection(withUrl: Constants.getApiUrl() + path)
  }
  
  func login(withName name: String, password: String, cb: @escaping (Bool) -> Void) {
    let parameters = "name=\(name)&password=\(password)"
    self.userConnection.post(atPath: "/login", withParameters: parameters, cb: { response in
      if response.isError {
        print(response.message)
      } else {
        _ = self.jar.getMeCookie()
  			cb(true)
      }
    })
  }
  
  func logout() {
    jar.clearCookies()
  }
}
