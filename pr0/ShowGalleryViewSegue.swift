//
//  ShowGalleryViewSegue.swift
//  pr0
//
//  Created by Björn Friedrichs on 30.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class ShowGalleryViewSegue: UIStoryboardSegue {
  override func perform() {
    let destination = (self.destination as! GalleryViewController)
    let source = (self.source as! SingleViewController)
    
    let container = source.parent as! ContainerController
    
    let firstView = source.view!
    let secondView = destination.view!
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    container.tabBarController?.tabBar.isHidden = false
    
    secondView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
    
    (container.tabBarController! as! TabController).isVisible = true
    
    UIView.animate(withDuration: 0.25, animations: { () -> Void in
      firstView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
      secondView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      
    }) { (Finished) -> Void in
      // swap container
      container.showGallery()
      destination.updateGallery()
			source.cleanupVideo()
      
      source.removeFromParentViewController()
    }
  }
}
