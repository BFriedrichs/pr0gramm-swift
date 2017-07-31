//
//  API.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class API {
  static let sharedInstance = API()

  let itemService : ItemService
  
  let itemStore: ItemStore
  
  fileprivate init() {
    self.itemService = ItemService()
    
    self.itemStore = ItemStore.sharedInstance
  }
}
