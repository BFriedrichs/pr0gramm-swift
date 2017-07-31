//
//  ItemService.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class ItemService {
  
  var path = "items"
  
  let url: String
  let itemConnection: Connection
  let thumbConnection: Connection
  
  let itemStorage = ItemStore.sharedInstance
  
  init() {
    self.url = URLService.apiUrl + path
    self.itemConnection = Connection(withUrl: self.url)
    self.thumbConnection = Connection(withUrl: URLService.thumbUrl)
  }
  
  func getItems(withOptions option: ItemOption?, cb: @escaping ([Item]) -> Void) {
   	let parameters = "/get\(option?.buildUrl() ?? "")"

    self.itemConnection.get(withParameters: parameters, parseJson: true, cb: { data in
      let json = data as! [String: Any]
      if let itemData = json["items"] as? [[String: Any]] {
        for retrievedData in itemData {
          let item = Item(withData: retrievedData)
          self.itemStorage.add(item)
        }
  			self.itemStorage.forceCacheUpdate()
        cb(self.itemStorage.storage)
      }
    })
  }
  
  func getItemThumb(forItem item: Item, cb: @escaping (Data) -> Void) {
    if item.thumbData != nil {
      cb(item.thumbData!)
    } else {
      let parameters = item.thumb
      self.thumbConnection.get(withParameters: parameters, cb: { data in
        if let data = data as? Data {
         	item.thumbData = data
          cb(data)
        }
      })
    }
  }

  func getItemComments(forItem item: Item, cb: ([Comment]) -> Void) {
    
  }
  
  func getItemTags(forItem item: Item, cb: ([Tag]) -> Void) {
    
  }
  
}
