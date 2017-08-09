//
//  Store.swift
//  pr0gramm-api
//
//  Created by Björn Friedrichs on 29.07.17.
//
//

import Foundation

extension Array where Element: Storable {
  func contains(_ element: Element) -> Bool {
    for e in self {
      if e.id == element.id {
        return true
      }
    }
    return false
  }
  
  func index(_ element: Element) -> Int? {
    for (i, e) in self.enumerated() {
      if e.id == element.id {
        return i
      }
    }
    return nil
  }
}

protocol Storable {
  var id: UInt32 { get }
  var type: StorageType { get }
}

class StorableElement: Storable {
  let id: UInt32
  let type: StorageType
  
  init(id: UInt32, type: StorageType) {
    self.id = id
    self.type = type
  }
}

class Store<T: Storable> {
  var size: Int {
    return storage.count
  }
  
  var storage = [T]()
  
  init() {
    
  }
  
  func add(_ element: T) {
    if !storage.contains(element) {
    	storage.append(element)
    }
  }
}

