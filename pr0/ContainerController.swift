//
//  ContainerController.swift
//  pr0
//
//  Created by Björn Friedrichs on 31.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class ContainerController: UIViewController {
  @IBOutlet var galleryContainer: UIView!
  @IBOutlet var singleContainer: UIView!
  
  var singleController: SingleViewController?
  var galleryController: GalleryViewController?
  
  func showSingle() {
    self.view.bringSubview(toFront: self.singleContainer)
  }
  
  func showGallery() {
    self.view.bringSubview(toFront: self.galleryContainer)
  }
  
  override func addChildViewController(_ childController: UIViewController) {
    super.addChildViewController(childController)
    
    if let controllerS = childController as? SingleViewController {
      singleController = controllerS
    } else if let controllerG = childController as? GalleryViewController {
      galleryController = controllerG
    }
  }
}
