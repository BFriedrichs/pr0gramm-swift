//
//  TagCell.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 06.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class TagCell: UICollectionViewCell {
  
  @IBOutlet var tagLabel: UILabel!
  
  var tag_: Tag?
  let api = API.shared
  
  func updateSelection() {
    let status = api.voteStore.getVote(forElement: tag_!)
    DispatchQueue.main.async {
			self.backgroundColor = Color.BackLighter
      
      switch status {
      case .Upvote:
        self.backgroundColor = Color.Highlight
        break;
      case .Downvote:
        self.backgroundColor = Color.HighlightBlue
      default: break
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.isSelected = false
    self.isHighlighted = false
    tag_ = nil
  }
}
