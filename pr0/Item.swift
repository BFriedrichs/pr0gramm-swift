//
//  Item.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class Item: Storeable {
  
  var id: Double
  var promoted: Double
  var isPromoted = false
  
  var up: Int
  var down: Int
  
  var created: Double
  var createdDate: Date
  
  var image: String
  var contentData: Data?
  var mediaType: MediaType
  
  var thumb: String
  var thumbData: Data?
  
  var fullsize: String
  
  var width: Int
  var height: Int
  
  var audio: Bool
  var source: String
  var flags: FlagStatus
  
  var user: String
  var mark: UserStatus
  
  var commentStore = CommentStore()
  var tagStore = TagStore()
  
  init(withData data: [String: Any]) {
    self.id = data["id"] as! Double
    self.promoted = data["promoted"] as! Double
    if promoted != 0 {
      self.isPromoted = true
    }
    
    self.up = data["up"] as! Int
    self.down = data["down"] as! Int
    
    self.created = data["created"] as! Double
    self.createdDate = Date.init(timeIntervalSince1970: TimeInterval(self.created))
    
    self.image = data["image"] as! String
    self.thumb = data["thumb"] as! String
    self.fullsize = data["fullsize"] as! String
    
    self.mediaType = MediaType.getMediaType(forURL: self.image)

    self.width = data["width"] as! Int
    self.height = data["height"] as! Int
    
    self.audio = data["audio"] as! Bool
    self.source = data["source"] as! String
    self.flags = FlagStatus(rawValue: data["flags"] as! Int)!
    
    self.user = data["user"] as! String
    self.mark = UserStatus(rawValue: data["mark"] as! Int)!
  }
}
