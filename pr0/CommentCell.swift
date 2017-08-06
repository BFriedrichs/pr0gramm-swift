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
  @IBOutlet var comment: UILabel!
  @IBOutlet var commentInsetConstraint: NSLayoutConstraint!
  @IBOutlet var user: UserLabel!
  @IBOutlet var points: UILabel!
  @IBOutlet var time: UILabel!
  
  override func prepareForReuse() {
    
    super.prepareForReuse()
  }
}
