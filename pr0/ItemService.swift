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
  let contentConnection: Connection
  
  let itemStorage = ItemStore.sharedInstance
  
	var allowPreload = true
  
  init() {
    self.url = Constants.getApiUrl() + path
    self.itemConnection = Connection(withUrl: self.url)
    self.thumbConnection = Connection(withUrl: Constants.getThumbUrl())
    self.contentConnection = Connection(withUrl: Constants.getImgUrl())
  }
  
  func getItems(withOptions option: ItemOption?, cb: @escaping ([Item]) -> Void) {
   	let parameters = "\(option?.buildUrl() ?? "")"

    self.itemConnection.get(atPath: "/get", withParameters: parameters, parseJson: true, cb: { data in
      let json = data as! [String: Any]
      if let itemData = json["items"] as? [[String: Any]] {
        var items = [Item]()
        for retrievedData in itemData {
          let item = Item(withData: retrievedData)
          self.itemStorage.add(item)
          items.append(item)
        }
        self.itemStorage.forceCacheUpdate(withOption: option)
        cb(items)
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
  
  func getItemContent(forItem item: Item, preloading: Bool = false, cb: @escaping (Data) -> Void = {_ in}) {
    if item.mediaType.mediaGroup == .VideoType {
      //shitty fix but Data -> Video convert not possible right now
      //so there is no use in downloading it
    	cb(Data())
      
      if preloading {
        return
      }
      
      self.preload(forItem: item)
      
      return
    }
    
    if item.contentData != nil {
      cb(item.contentData!)
      if !preloading {
        self.preload(forItem: item)
      }
    } else {
      print(item.image)
      
      let parameters = item.image
      self.contentConnection.get(withParameters: parameters, cb: { data in
        if let data = data as? Data {
          
          if preloading {
            print("preload done")
           	item.contentData = data
            self.itemStorage.addToCache(item)
            
            return
          }
          
          cb(data)
          
          self.preload(forItem: item)
        }
      })
    }
  }
  
  func preload(forItem item: Item) {
    if self.allowPreload {
      let index = self.itemStorage.indexInCache(forItem: item)!
      
      let nextItem = self.itemStorage.itemInCache(forIndex: index + 1)
      if nextItem != nil {
        self.getItemContent(forItem: nextItem!, preloading: true)
      }
      
      let nextNextItem = self.itemStorage.itemInCache(forIndex: index + 2)
      if nextNextItem != nil {
        self.getItemContent(forItem: nextNextItem!, preloading: true)
      }
      
    }
  }
	
  func getNextItem(after item: Item, cb: @escaping (Item?) -> Void) {
    let index = itemStorage.indexInCache(forItem: item)
    let size = itemStorage.sizeOfCache()
    
    guard let itemIndex = index else {
      cb(nil)
      return
    }
    
    if size != nil && itemIndex == size! - 1 {
      var olderOption = itemStorage.lastOption!
    	olderOption.setOlder(thanItem: item)
      
      self.getItems(withOptions: olderOption, cb: { items in
        cb(items.first)
      })
      return
    }
    
    let nextItem = itemStorage.itemInCache(forIndex: itemIndex + 1)
    cb(nextItem)
  }
  
  func getPreviousItem(before item: Item, cb: @escaping (Item?) -> Void) {
    let index = itemStorage.indexInCache(forItem: item)
    
    guard let itemIndex = index else {
      cb(nil)
      return
    }
    
    if itemIndex == 0 {
      var newerOption = itemStorage.lastOption!
      newerOption.setNewer(thanItem: item)
      
      self.getItems(withOptions: newerOption, cb: { items in
        cb(items.last)
      })
      return
    }
    
    let previousItem = itemStorage.itemInCache(forIndex: itemIndex - 1)
    cb(previousItem)
  }

  func getItemMeta(forItem item: Item, cb: @escaping (StorageType) -> Void) {
    let parameters = "?itemId=\(item.id)"
    
    self.itemConnection.get(atPath: "/info", withParameters: parameters, parseJson: true, cb: { data in
      let json = data as! [String: Any]
      if let commentData = json["comments"] as? [[String: Any]] {
        for retrievedData in commentData {
          let comment = Comment(withData: retrievedData)
          item.commentStore.add(comment)
        }
        cb(.Comment)
      }
      
      if let tagData = json["tags"] as? [[String: Any]] {
        for retrievedData in tagData {
          let tag = Tag(withData: retrievedData)
          item.tagStore.add(tag)
        }
        cb(.Tag)
      }
    })
  }
  
  func getItemTags(forItem item: Item, cb: ([Tag]) -> Void) {
    
  }
  
}
