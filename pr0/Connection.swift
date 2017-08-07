//
//  Connection.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

typealias PostResponse = (isError: Bool, message: String, data: Any?)

class Connection {
  let url: String
  let session: URLSession

  init(withUrl url: String) {
    self.url = url
    self.session = URLSession.shared
  }
  
  func get(atPath path: String = "", withParameters parameters: String, parseJson: Bool = false, cb: @escaping (Any) -> Void) {
    let getUrl = URL(string: url + path + parameters)!
    
    let task = session.dataTask(with: getUrl) { (data, response, error) in
      if error != nil {
        print(error ?? "Error occurred on connection.")
      } else {
        if let usableData = data {
          if parseJson {
            let parsed = self.parseData(data: usableData)
						if parsed != nil {
             	cb(parsed!)
            }
          } else {
            cb(usableData)
          }
        }
      }
    }
    task.resume()
  }
  
  func post(atPath path: String = "", withParameters parameters: String, cb: @escaping (PostResponse) -> Void) {
    print("post: \(self.url + path) - \(parameters)")
    let postURL = URL(string: self.url + path)
    
    var postRequest = RequestBuilder.buildRequest(withUrl: postURL!, method: "POST")
    postRequest.httpBody = parameters.data(using: .utf8)
    
    let task = session.dataTask(with: postRequest) { data, response, error in
      if error != nil {
        print(error ?? "Error occurred on connection.")
        cb((true, error.debugDescription, nil))
      } else {
        if let usableData = data {
          let parsed = self.parseData(data: usableData)
          if parsed != nil {
            cb((false, "", parsed))
          }
        }
      }
    }
    task.resume()
  }
  
  func parseData(data : Data) -> [String: Any]? {
    do {
      return try JSONSerialization.jsonObject(with: data) as? [String: Any]
    } catch {
      print("Error deserializing JSON: \(error)")
    }
    return nil
  }
}
