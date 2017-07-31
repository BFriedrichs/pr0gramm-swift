//
//  Store.swift
//  pr0gramm-api
//
//  Created by Björn Friedrichs on 29.07.17.
//
//

import Foundation

extension Array where Element: Storeable {
  func contains(_ element: Element) -> Bool {
    for e in self {
      if(e.id == element.id) {
        return true
      }
    }
    return false
  }
}

protocol Storeable {
  var id: Double { get }
}

class Store<T: Storeable> {
  var storage = [T]()
  
  init() {
    
  }
  
  func add(_ element: T) {
    if !storage.contains(element) {
    	storage.append(element)
    }
  }
}

