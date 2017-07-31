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
    // Assign the source and destination views to local variables.
    
    let destination = (self.destination as! GalleryViewController)
    let source = (self.source as! SingleViewController)
    
    let container = source.parent as! ContainerController
    
    let firstView = source.view!
    let secondView = destination.view!
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    secondView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
    
    UIView.animate(withDuration: 0.25, animations: { () -> Void in
      firstView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
      secondView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      
    }) { (Finished) -> Void in
      // swap container
      container.containerGallery.removeFromSuperview()
      container.view.addSubview(container.containerGallery)
      
      source.removeFromParentViewController()
    }
  }
}
