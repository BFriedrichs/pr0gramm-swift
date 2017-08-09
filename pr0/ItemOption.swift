//
//  ItemOption.swift
//  pr0gramm-api
//
//  Created by Björn Friedrichs on 29.07.17.
//
//

import Foundation

struct ItemOption {
  var flags: [FlagStatus]
  var promoted: Bool
  var older: UInt32?
  var newer: UInt32?
  
  func buildUrl() -> String {
    let olderStr = older != nil ? "&older=\(UInt32(older!))" : ""
    let newerStr = newer != nil ? "&newer=\(UInt32(newer!))" : ""
    return "?flags=\(flags.reduce(0, { return $0 + $1.rawValue }))" +
      			"&promoted=\(promoted ? 1 : 0)" +
    				"\(olderStr)" +
    				"\(newerStr)"
  }
  
  init(flags: [FlagStatus], promoted: Bool) {
    self.flags = flags
    self.promoted = promoted
  }
  
  init(flags: [FlagStatus], promoted: Bool, older: UInt32) {
    self.init(flags: flags, promoted: promoted)
    self.older = older
  }
  
  init(flags: [FlagStatus], promoted: Bool, newer: UInt32) {
    self.init(flags: flags, promoted: promoted)
    self.newer = older
  }
  
  mutating func setOlder(thanItem item: Item) {
    self.older = item.isPromoted ? item.promoted : item.id
  }
  
  mutating func setNewer(thanItem item: Item) {
    self.newer = item.isPromoted ? item.promoted : item.id
  }
}

extension ItemOption: Equatable {}

func ==(lhs: ItemOption, rhs: ItemOption) -> Bool {
  return lhs.flags == rhs.flags &&
    rhs.promoted == lhs.promoted
}
