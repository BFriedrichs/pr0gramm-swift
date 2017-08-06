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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.isSelected = false
    self.isHighlighted = false
  }
}
