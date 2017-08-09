//
//  API.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class API {
  static let shared = API()

  let userService: UserService
  let itemService: ItemService
  let tagService: TagService
  let commentService: CommentService
  let syncService: SyncService
  
  let itemStore: ItemStore
  let voteStore: VoteStore
  
  fileprivate init() {
    self.userService = UserService()
    self.itemService = ItemService()
    self.tagService = TagService()
    self.commentService = CommentService()
    self.syncService = SyncService()
    
    self.itemStore = ItemStore.shared
    self.voteStore = VoteStore.shared
  }
}
