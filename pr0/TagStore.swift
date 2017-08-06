//
//  TagStore.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 06.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

final class TagStore: Store<Tag> {
  override init() {
    
	}
  
  override func add(_ element: Tag) {
    if !storage.contains(element) {
      storage.append(element)
      updateSort()
    }
  }
  
  func updateSort() {
    self.storage.sort(by: {
      return $0.confidence > $1.confidence
    })
  }
  
}
