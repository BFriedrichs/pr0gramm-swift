//
//  CommentStore.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 04.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

final class CommentStore: Store<Comment> {
  override init() {
    
  }
  
  override func add(_ element: Comment) {
    if !storage.contains(element) {
      storage.append(element)
      updateSort()
      updateRelations()
    }
  }
  
  func updateSort() {
    self.storage.sort(by: {
      let score0 = $0.up - $0.down
      let score1 = $1.up - $1.down
      return score0 > score1
    })
  }
  
	/*
 		[updateRelations -> orderChilds] will create a flattened version of the comment child-parent relationship
   
    ex: [c1, c1.1, c1.2, c1.2.1, c1.2.2, c2]
   
   	Note: Could use confidence but depth is needed for displaying right now, maybe needs refactor
 	*/
  func updateRelations() {
    self.storage = orderChilds(forList: self.storage.filter({ return !$0.hasParent }))
  }
  
  func orderChilds(forList list: [Comment], depth: Int = 0) -> [Comment] {
    var result = [Comment]()
    for c in list {
      c.depth = depth
      result.append(c)
      result.append(contentsOf: orderChilds(forList: getChilds(forComment: c), depth: depth + 1))
    }
    return result
  }

  func getChilds(forComment comment: Comment) -> [Comment] {
    return self.storage.filter({ return $0.parent == comment.id })
  }

  func getComments() -> [Comment] {
    guard self.storage.count > 0 else {
      return []
    }
    
    return self.storage
  }

  func findComment(withId id: UInt32) -> Comment? {
    return self.storage.filter({ return id == $0.id })[0]
  }
  
  func findCommentIndex(withId id: UInt32, inList list: [Comment]) -> Int {
    return list.index(where: { return $0.id == id })!
  }
}
