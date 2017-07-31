//
//  SettingsStore.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

final class SettingsStore {
  static let sharedInstance = SettingsStore()
  
  static let FILTER_CHANGED = "filter_changed"
  
  let storage = UserDefaults.standard
  
  var filter : Set<FlagStatus> {
    didSet {
      let filterArray = filter.map({ return $0.rawValue })
      storage.set(filterArray, forKey: "filter")
      storage.synchronize()
    }
  }
  
  var promoted : Bool {
    didSet {
      storage.set(promoted, forKey: "promoted")
      storage.synchronize()
    }
  }
  
  func generateOption() -> ItemOption {
    return ItemOption(flags: Array(self.filter), promoted: self.promoted)
  }
  
  private init() {
    
    let filterArray = storage.value(forKey: "filter") as? [Int] ?? [1]
    self.filter = Set<FlagStatus>(filterArray.map { FlagStatus(rawValue: $0) } as! [FlagStatus])

    self.promoted = storage.value(forKey: "promoted") as? Bool ?? true
  }
	
}
