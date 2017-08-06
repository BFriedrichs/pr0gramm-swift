//
//  Tag.swift
//  pr0gramm-api
//
//  Created by Björn Friedrichs on 29.07.17.
//
//

import Foundation

class Tag: Storeable {
  var id: Double
  
  var confidence: Double
  
  var tag: String
  
  init(withData data: [String: Any]) {
    self.id = data["id"] as! Double
    
    self.confidence = data["confidence"] as! Double
    
		self.tag = data["tag"] as! String
  }

}
