//
//  SingleViewSegue.swift
//  pr0
//
//  Created by Björn Friedrichs on 30.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import UIKit

class ShowSingleViewSegue: UIStoryboardSegue {

  override func perform() {
    // Assign the source and destination views to local variables.
    
    let destination = (self.destination as! SingleViewController)
    let source = (self.source as! GalleryViewController)
    
    let container = source.parent as! ContainerController

    let galleryView = source.view!
    let singleView = destination.view!
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    container.addChildViewController(destination)
    
    container.containerSingle.subviews[0].removeFromSuperview()
    container.containerSingle.addSubview(singleView)
    
    let imageView = UIImageView(image: destination.initImage)
    imageView.contentMode = .scaleAspectFit
    destination.contentView.addSubview(imageView)
    
    container.containerSingle.frame = destination.initSize!
    container.containerSingle.clipsToBounds = true
    
    // swap container
    container.containerSingle.removeFromSuperview()
    container.view.addSubview(container.containerSingle)
    
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: { () -> Void in
      imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      container.containerSingle.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      
    }) { (Finished) -> Void in
      destination.didMove(toParentViewController: container)
    }
  }
}
