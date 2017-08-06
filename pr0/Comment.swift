//
//  Comment.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class Comment: Storeable {
  var id: Double
  
  var parent: Double
  var hasParent = false
  var depth = 0
  var content: String
  
  var created: Double
  var createdDate: Date
  
  var up: Int
  var down: Int
  
  var confidence: Double
  
  var user: String
  var mark: UserStatus
  
  init(withData data: [String: Any]) {
    self.id = data["id"] as! Double
    
    self.parent = data["parent"] as! Double
    if(self.parent != 0) {
      self.hasParent = true
    }
    
    self.content = data["content"] as! String
    
    self.created = data["created"] as! Double
    self.createdDate = Date.init(timeIntervalSince1970: TimeInterval(self.created))
    
    self.up = data["up"] as! Int
    self.down = data["down"] as! Int
    
    self.confidence = data["confidence"] as! Double
    
    self.user = data["name"] as! String
    self.mark = UserStatus(rawValue: data["mark"] as! Int)!
  }
}
