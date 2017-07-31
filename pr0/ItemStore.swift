//
//  ItemStore.swift
//  pr0gramm-api
//
//  Created by Björn Friedrichs on 29.07.17.
//
//

import Foundation

final class ItemStore: Store<Item> {
  static var sharedInstance = ItemStore()
	
  var lastContent : [Item]?
  var lastOption : ItemOption?
  
  override init() {
    
  }
  
  func hasItems(withOptions option: ItemOption) -> Bool {
    let items = getFilteredContent(withOption: option)
    return items.count > 0
  }
  
  func getOldestItem(withOptions option: ItemOption) -> Item? {
    if hasItems(withOptions: option) {
      let items = getFilteredContent(withOption: option)
      return items.last!
    }
  	return nil
  }
  
  func forceCacheUpdate() {
    guard let lastOption = lastOption else {
      return
    }
    _ = self.getFilteredContent(withOption: lastOption, forceUpdate: true)
  }

  func getFilteredContent(withOption option: ItemOption, forceUpdate: Bool = false) -> [Item] {
    if !forceUpdate && lastContent != nil && lastContent!.count > 0 && lastOption != nil && option == lastOption! {
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
