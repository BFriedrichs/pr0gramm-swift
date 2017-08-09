//
//  CommentCell.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 04.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {
  
  @IBOutlet var downvote: UIButton!
  @IBOutlet var upvote: UIButton!
  @IBOutlet var commentLabel: UILabel!
  @IBOutlet var commentInsetConstraint: NSLayoutConstraint!
  @IBOutlet var user: UserLabel!
  @IBOutlet var points: UILabel!
  @IBOutlet var time: UILabel!
  
  var comment: Comment?
  let api = API.shared
  
  @IBAction func upvoteButtonPressed(_ sender: UIButton) {
    let status = api.voteStore.getNextStatus(forElement: comment!, withTransition: .Upvote)
    api.commentService.vote(forComment: comment!, transitionTo: status, cb: { response in
      if response.needsLogin {
        Dialog.needsLogin()
      } else {
        self.updateSelection()
      }
    })
  }
  
  @IBAction func downvoteButtonPressed(_ sender: UIButton) {
    let status = api.voteStore.getNextStatus(forElement: comment!, withTransition: .Downvote)
    api.commentService.vote(forComment: comment!, transitionTo: status, cb: { response in
      if response.needsLogin {
        Dialog.needsLogin()
      } else {
        self.updateSelection()
      }
    })
  }
  
  func updateSelection() {
    let status = api.voteStore.getVote(forElement: comment!)
    DispatchQueue.main.async {
      self.downvote.isSelected = false
      self.upvote.isSelected = false

      switch status {
      case .Upvote:
        self.upvote.isSelected = true
        break;
      case .Downvote:
        self.downvote.isSelected = true
      default: break
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    comment = nil
    upvote.isSelected = false
    downvote.isSelected = false
  }
}
