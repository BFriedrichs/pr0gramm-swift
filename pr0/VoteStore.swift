//
//  VoteStore.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 07.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

typealias VoteDict = [UInt32: VoteStatus]

class VoteStore {
  
  static let shared = VoteStore()
  private var storage: [StorageType: VoteDict]
  
  // 1: is currently
  // 2: is requested
  // 3: result
  private var transitionMatrix: [VoteStatus: [VoteStatus: VoteStatus]] = [
    .Like: [.Like: .Upvote, .Upvote: .Like, .Downvote: .Like],
  	.Upvote: [.Like: .Like, .Upvote: .None, .Downvote: .Downvote],
  	.None: [.Like: .Like, .Upvote: .Upvote, .Downvote: .Downvote],
  	.Downvote: [.Like: .Like, .Upvote: .Upvote, .Downvote: .None]
  ]
  
  func getNextStatus(forElement e: Storable, withTransition transition: VoteStatus) -> VoteStatus {
    return transitionMatrix[getVote(forElement: e)]![transition]!
  }
  
  private init() {
    self.storage = [.Item: VoteDict(),
                    .Comment: VoteDict(),
                    .Tag: VoteDict()]
    
  }
  
  func setVote(forElement e: Storable, withTransition transition: VoteStatus) {
    guard self.storage.keys.contains(e.type) else {
      print("FATAL: \(e.type) not a valid type")
      return
    }
		
    var storage = self.storage[e.type]!
    if transition == .None && storage.keys.contains(e.id) {
      storage.removeValue(forKey: e.id)
    } else {
      storage[e.id] = transition
    }
    self.storage[e.type]! = storage
  }
  
  func getVote(forElement e: Storable) -> VoteStatus {
    guard self.storage.keys.contains(e.type) else {
      print("FATAL: \(e.type) not a valid type")
      return .None
    }
    
    return self.storage[e.type]![e.id] ?? .None
  }
}
