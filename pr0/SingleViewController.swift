//
//  SingleViewController.swift
//  pr0
//
//  Created by Björn Friedrichs on 30.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class SingleViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet var contentView: UIScrollView!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var videoView: UIView!
  
  var initSize: CGRect!
  var initImage: UIImage!
  var item: Item!
  
  var willClose = false
  var isZoomed: Bool {
    return contentView.zoomScale != CGFloat(1)
  }
  var videoController: AVPlayerViewController!
  
  let api = API.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.hidesBackButton = true
    
    contentView.minimumZoomScale = 0.5;
    contentView.maximumZoomScale = 6.0;
    contentView.decelerationRate = UIScrollViewDecelerationRateFast
    updateScrollViewSize()
  }
  
  func handleData(_ data: Data) {
    let type = item.mediaType
    if type.mediaGroup == .ImageType {
      
      let image = UIImage.generateImage(fromType: type, withData: data)
      
      let desiredImageWidth = view.frame.width - 16
      
      let aspect = image.size.height / image.size.width
      
      self.videoView.isHidden = true
      self.imageView.isHidden = false
      DispatchQueue.main.async {
        self.imageView.frame = CGRect(x: 8, y: 75, width: desiredImageWidth, height: desiredImageWidth * aspect)
        
        self.imageView.image = image
        self.imageView.setNeedsDisplay()
        self.updateScrollViewSize()
      }
    } else if type.mediaGroup == .VideoType {
      initPlayer()
    }
  }
  
  func initPlayer() {
    videoController = AVPlayerViewController()
    addChildViewController(videoController)
    
    let url = URL(string: "https://img.pr0gramm.com/\(item.image)")
    let videoPlayer = AVPlayer(url: url!)
    videoController.player = videoPlayer
    
    let size = videoPlayer.currentItem!.asset.tracks(withMediaType: AVMediaTypeVideo)[0].naturalSize
    let aspect = size.height / size.width
    
    let screenSize = UIScreen.main.bounds
    
    var x : CGFloat = 8
    var desiredVideoWidth = screenSize.width - 16
  	var desiredVideoHeight = desiredVideoWidth * aspect
    
    if screenSize.height - 103 < desiredVideoHeight {
      desiredVideoHeight -= 103
      desiredVideoWidth = desiredVideoHeight / aspect
      x = (screenSize.width - desiredVideoWidth) / 2
    }
    
    self.videoView.isHidden = false
    self.imageView.isHidden = true
    
    DispatchQueue.main.async {
    	self.videoView.frame = CGRect(x: x, y: 75, width: desiredVideoWidth, height: desiredVideoHeight)
    	self.videoController.view.frame = CGRect(origin: CGPoint.zero, size: self.videoView.frame.size)

    	self.videoView.addSubview(self.videoController.view)
    }
  }
  
  func updateScrollViewSize() {
    var contentRect = CGRect.zero
    for view in contentView.subviews {
      contentRect = contentRect.union(view.frame)
    }
    contentView.contentSize = contentRect.size.applying(CGAffineTransform.init(scaleX: 0, y: 2))
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if self.isZoomed {
      return
    }
    
    let offsetTop = contentView.contentOffset.y
    if view.frame.minY > 0 || offsetTop < 0 {
      scrollView.contentOffset.y = 0
      self.view.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.minY-offsetTop), size: self.view.frame.size)
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if self.isZoomed {
      return
    }
    
    animateBack()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if self.isZoomed {
      return
    }
    
    let offsetTop = view.frame.minY
    let offsetLeft = contentView.contentOffset.x
  	
    if offsetLeft != 0 {
      if offsetLeft > 0 {
        print("pulled to left")
        API.sharedInstance.itemService.getNextItem(after: self.item, cb: { item in
          if item != nil {
            DispatchQueue.main.async {
              self.performShowNextItem(withItem: item!)
            }
          } else {
            Dialog.noOlderItem(self)
          }
        })
      } else {
        print("pulled to right")
        API.sharedInstance.itemService.getPreviousItem(before: self.item, cb: { item in
          if item != nil {
            DispatchQueue.main.async {
              self.performShowPreviousItem(withItem: item!)
            }
          } else {
            Dialog.noNewerItem(self)
          }
        })
      }
    } else if offsetTop > self.initSize!.height {
      print("go back")
      willClose = true
      
      performSegue(withIdentifier: "GalleryViewSegue", sender: self)
    } else {
      animateBack()
    }
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.imageView
  }
  
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    contentView.setZoomScale(1, animated: true)
  }
  
  var isAnimating = false
  func animateBack() {
    if !willClose && self.view.frame.minY > 0 {
      UIView.animate(withDuration: 0.3, animations: { () -> Void in
        self.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size)
      }) { (Finished) -> Void in
        self.isAnimating = false
      }
    }
  }
  
  func cleanupVideo(removeFromView remove: Bool = false) {
    if videoController != nil {
      if remove {
        self.videoController.view.removeFromSuperview()
      }
      if videoController.player != nil {
        videoController.player!.pause()
        videoController.player = nil
      }

      videoController.removeFromParentViewController()
    }
  }
  
  func performShowNextItem(withItem item: Item) {
    ActivityIndicator.show()
    cleanupVideo(removeFromView: true)
    
   	let copy = contentView.deepCopy__EXPENSIVE()
    
    let screenWidth = UIScreen.main.bounds.width
    
    contentView.frame.origin = CGPoint(x: screenWidth, y: 0)
  	view.addSubview(copy)
    
    self.item = item
    self.imageView.image = nil
    api.itemService.getItemContent(forItem: item, cb: { data in
      self.handleData(data)
      ActivityIndicator.hide()
    })
    
    contentView.setContentOffset(CGPoint.zero, animated: false)
    
    UIView.animate(withDuration: 0.4, animations: {
      copy.frame.origin = CGPoint(x: -screenWidth, y: 0)
      self.contentView.frame.origin = CGPoint.zero
    }) { finished in
      DispatchQueue.main.async {
        copy.removeFromSuperview()
      }
    }
  }
  
  func performShowPreviousItem(withItem item: Item) {
    ActivityIndicator.show()
    
    cleanupVideo(removeFromView: true)
    
   	let copy = contentView.deepCopy__EXPENSIVE()
    
    let screenWidth = UIScreen.main.bounds.width
    
    contentView.frame.origin = CGPoint(x: -screenWidth, y: 0)
    view.addSubview(copy)
    
    self.item = item
    self.imageView.image = nil
    contentView.setContentOffset(CGPoint.zero, animated: false)
    
    api.itemService.getItemContent(forItem: item, cb: { data in
      self.handleData(data)
      ActivityIndicator.hide()
    })
    
    UIView.animate(withDuration: 0.4, animations: {
      copy.frame.origin = CGPoint(x: screenWidth, y: 0)
      self.contentView.frame.origin = CGPoint.zero
    }) { finished in
      DispatchQueue.main.async {
        copy.removeFromSuperview()
      }
    }
  }
}
