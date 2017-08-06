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
    ActivityIndicator.show()
    let api = API.sharedInstance
    
    let destination = (self.destination as! SingleViewController)
    let source = (self.source as! GalleryViewController)
    
    let container = source.parent as! ContainerController

    _ = container.childViewControllers.map({
      if let _ = $0 as? SingleViewController {
        $0.removeFromParentViewController()
      }
    })
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    //destination.view.translatesAutoresizingMaskIntoConstraints = false
    
    destination.willMove(toParentViewController: container)
    container.addChildViewController(destination)
    
    let _ = container.singleContainer.subviews.map({
      $0.removeFromSuperview()
    })
    
    container.singleContainer.addSubview(destination.view)
    let singleController = container.singleController!
    singleController.resetView()
    
    singleController.view.frame = destination.initSize!
    singleController.view.clipsToBounds = true
    
    singleController.imageView.image = destination.initImage
    //singleController.imageView.frame = CGRect(origin: CGPoint.zero, size: destination.initSize!.size)
    
		container.showSingle()
    
   let desiredImageWidth = screenWidth - 16
    
    api.itemService.getItemContent(forItem: destination.item, cb: { data in
      singleController.handleData(data)
      ActivityIndicator.hide()
    })
    
    (container.tabBarController! as! TabController).isVisible = false
    
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: { () -> Void in
      //imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      singleController.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      singleController.imageView.frame = CGRect(x: 0, y: 0, width: desiredImageWidth, height: desiredImageWidth)
      
    }) { (Finished) -> Void in
      destination.didMove(toParentViewController: container)
    }
  }
}
