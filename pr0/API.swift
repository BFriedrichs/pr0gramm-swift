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

  let userService: UserService
  let itemService: ItemService
  let tagService: TagService
  let commentService: CommentService
  
  let itemStore: ItemStore
  
  fileprivate init() {
    self.userService = UserService()
    self.itemService = ItemService()
    self.tagService = TagService()
    self.commentService = CommentService()
    
    self.itemStore = ItemStore.sharedInstance
  }
}
