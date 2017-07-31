//
//  Connection.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class Connection {
  let url: String
  
  init(withUrl url: String) {
    self.url = url
  }
  
  func get(withParameters parameters: String, parseJson: Bool = false, cb: @escaping (Any) -> Void) {
    let postUrl = URL(string: url + parameters)!
    
    let task = URLSession.shared.dataTask(with: postUrl) { (data, response, error) in
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
  
  func parseData(data : Data) -> [String: Any]? {
    do {
      return try JSONSerialization.jsonObject(with: data) as? [String: Any]
    } catch {
      print("Error deserializing JSON: \(error)")
    }
    return nil
  }
}
