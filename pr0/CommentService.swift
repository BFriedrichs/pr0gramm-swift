//
//  CommentService.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 07.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class CommentService: Service {
  
  let path = "comments"
  
  let jar = CookieJar.shared
  
  let commentConnection: Connection
  let voteStore = VoteStore.shared
  
  init() {
    self.commentConnection = Connection(withUrl: Constants.getApiUrl() + path)
  }
  
  func vote(forComment comment: Comment, transitionTo transition: VoteStatus, cb: @escaping (PostResponse) -> Void) {
    let _nonce = jar.getCurrentNonce()
    if _nonce != nil {
      let parameters = "id=\(comment.id)&vote=\(transition.rawValue)&_nonce=\(_nonce!)"
      self.commentConnection.post(atPath: "/vote", withParameters: parameters, cb: { response in
        if !response.error {
          self.voteStore.setVote(forElement: comment, withTransition: transition)
        }
        cb((false ,!response.error))
      })
    } else {
      cb((true, false))
    }
  }
}
