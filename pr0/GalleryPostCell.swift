//
//  GalleryPostCell.swift
//  pr0
//
//  Created by Björn Friedrichs on 28.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class GalleryPostCell: UICollectionViewCell {
  @IBOutlet var postPreview: UIImageView!
  
  var item : Item?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    DispatchQueue.main.async {
      self.postPreview.image = nil
      self.postPreview.setNeedsDisplay()
    }
  }
}
