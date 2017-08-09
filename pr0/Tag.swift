//
//  Tag.swift
//  pr0gramm-api
//
//  Created by Björn Friedrichs on 29.07.17.
//
//

import Foundation

class Tag: Storable {
  
  let type = StorageType.Tag
  
  var id: UInt32
  
  var confidence: Double
  
  var tag: String
  
  init(withData data: [String: Any]) {
    self.id = data["id"] as! UInt32
    
    self.confidence = data["confidence"] as! Double
    
		self.tag = data["tag"] as! String
  }

}
