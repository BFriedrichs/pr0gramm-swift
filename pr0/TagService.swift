//
//  TagService.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 07.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation

class TagService: Service {
  
  let path = "tags"
  let jar = CookieJar.shared
  
  let tagConnection: Connection
  let voteStore = VoteStore.shared
  
  init() {
    self.tagConnection = Connection(withUrl: Constants.getApiUrl() + path)
  }
  
  func vote(forTag tag: Tag, transitionTo transition: VoteStatus, cb: @escaping (PostResponse) -> Void) {
    let _nonce = jar.getCurrentNonce()
    if _nonce != nil {
      let parameters = "id=\(tag.id)&vote=\(transition.rawValue)&_nonce=\(_nonce!)"
      self.tagConnection.post(atPath: "/vote", withParameters: parameters, cb: { response in
        if !response.error {
          self.voteStore.setVote(forElement: tag, withTransition: transition)
        }
        cb((false ,!response.error))
      })
    } else {
      cb((true, false))
    }
  }
}
