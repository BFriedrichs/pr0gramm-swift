//
//  ItemStore.swift
//  pr0gramm-api
//
//  Created by Björn Friedrichs on 29.07.17.
//
//

import Foundation

final class ItemStore: Store<Item> {
  static var shared = ItemStore()
	
  var lastContent : [Item]?
  var lastOption : ItemOption?
  
  var maxImageCacheSize = 20000000 // 20 mbyte
  var imageCacheSize = 0
  var imageCache = [(item: Item, size: Int)]()
  
  override init() {
    
  }
  
  func addToCache(_ item: Item) {
    imageCacheSize += item.contentData!.count
    // insert tuple to avoid clogging the cache with unloaded sizes
    imageCache.insert((item, item.contentData!.count), at: 0)
    
    if imageCacheSize > maxImageCacheSize {
      let cachedItem = imageCache.popLast()!
      imageCacheSize -= cachedItem.size
      cachedItem.item.contentData = nil
    }
    
    print(imageCacheSize)
  }
  
  func hasItems(withOptions option: ItemOption) -> Bool {
    let items = getFilteredContent(withOption: option)
    return items.count > 0
  }
  
  func getOldestItem(withOptions option: ItemOption? = nil) -> Item? {
    let option = option ?? lastOption!
    if hasItems(withOptions: option) {
      let items = getFilteredContent(withOption: option)
      return items.last!
    }
  	return nil
  }
  
  func isCached(option: ItemOption) -> Bool {
    return lastOption != nil && lastOption == option
  }
  
  func indexInCache(forItem item: Item) -> Int? {
    guard let lastContent = self.lastContent else {
      return nil
    }
    
    return lastContent.index(item)
  }
  
  func itemInCache(forIndex index: Int) -> Item? {
    guard let lastContent = self.lastContent else {
      return nil
    }
    
    return lastContent[index]
  }
  
  func sizeOfCache() -> Int? {
    guard let lastContent = self.lastContent else {
      return nil
    }
    
    return lastContent.count
  }
  
  func forceCacheUpdate(withOption option: ItemOption? = nil) {
    if option != nil {
      _ = self.getFilteredContent(withOption: option!, forceUpdate: true)
    } else {
      guard let lastOption = lastOption else {
        return
      }
      
      _ = self.getFilteredContent(withOption: lastOption, forceUpdate: true)
    }
  }
  
  func getFilteredContent(withOption option: ItemOption, forceUpdate: Bool = false) -> [Item] {
    guard self.storage.count > 0 else {
      return []
    }
    
    if !forceUpdate && lastContent != nil && lastContent!.count > 0 && isCached(option: option) {
      return lastContent!
    } else {
      let filtered = self.storage.filter({
        return option.flags.contains($0.flags) && option.promoted == $0.isPromoted
      })
      
    	let sorted = filtered.sorted(by: {
        return $0.created > $1.created
      })

      lastContent = sorted
      lastOption = option
        
      return sorted
    }
  }
}
