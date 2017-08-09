//
//  SyncService.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 09.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

typealias SyncResponse = (success: Bool, offset: Int)

class SyncService: Service {
  
  let path = "user/sync"
  
  let voteStore = VoteStore.shared
  let syncConnection: Connection
  
  let actions: [(type: StorageType, status: VoteStatus)?] = [
    nil,
    (.Item, .Downvote),
    (.Item, .None),
    (.Item, .Upvote),
    (.Comment, .Downvote),
    (.Comment, .None),
    (.Comment, .Upvote),
    (.Tag, .Downvote),
    (.Tag, .None),
    (.Tag, .Upvote),
    (.Item, .Like)
  ]
  
	init() {
    self.syncConnection = Connection(withUrl: Constants.getApiUrl() + path)
  }
  
  func sync(fromOffset: Int = 0, cb: @escaping (SyncResponse) -> Void) {
    let parameters = "?offset=\(fromOffset)"
   	self.syncConnection.get(withParameters: parameters, parseJson: true, cb: { response in
      if !response.error {
        if let json = response.data! as? [String: Any] {
          let log = json["log"] as! String
          self.parseLog(log: log)

          cb((true, json["logLength"] as! Int))
          return
        }
      }
      cb((false, 0))
    })
  }
  
  private func parseLog(log: String) {
    var buffer = _base64ToArrayBuffer(base64: log)
    if buffer != nil {
      var i = 0
      while i < buffer!.count {
        /// retrive action from buffer at every 5th byte
        let actionIndex = Int(buffer![i + 4])
        let action = actions[actionIndex]!
        
        // retrieve id from 0-4th byte
        let buffer32 = buffer![i...i+3].map({ UInt32($0) })
        let int32 = buffer32.enumerated().reduce(0, { r, s in r + (UInt32(s.element) << UInt32(s.offset * 8)) })
        let id = UInt32(littleEndian: int32)
        
        voteStore.setVote(forElement: StorableElement(id: id, type: action.type), withTransition: action.status)

        i += 5
      }
    }
  }
  
  private func _base64ToArrayBuffer(base64: String) -> [UInt8]? {
    if let bin = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) {
      return Array(bin)
    }
    
    return nil
  }
}
