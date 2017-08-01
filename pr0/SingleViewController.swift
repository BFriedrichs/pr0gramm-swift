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
  
  let settings = SettingsStore.sharedInstance
  
  var cachedItem: AVPlayerItem?
  
  var willClose = false
  var isAnimating = false
  
  var isZoomed: Bool {
    return contentView.zoomScale != CGFloat(1)
  }
  
  var videoController: AVPlayerViewController!
  var hasVideo: Bool {
    return self.videoController != nil && self.videoController!.player != nil
  }
  
  let api = API.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.hidesBackButton = true
    
    let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.tappedVideo(sender:)))
    videoView.addGestureRecognizer(gesture)
    
    contentView.decelerationRate = UIScrollViewDecelerationRateFast
    
    NotificationCenter.default.addObserver(self, selector: #selector(setAudio), name: Notification.Name(rawValue: SettingsStore.AUDIO_CHANGED), object: nil)
    
    updateScrollViewSize()
  }
  
  func setAudio() {
    if videoController != nil && videoController!.player != nil {
      videoController.player!.isMuted = !settings.audio
    }
  }
  
  func tappedVideo(sender: UITapGestureRecognizer) {
    print("tapped video")
    if hasVideo {
      guard videoController.player!.currentItem == nil else {
        return
      }
      
      videoController.player!.replaceCurrentItem(with: cachedItem)
      cachedItem = nil
      videoController.player!.play()
      videoController.view.isUserInteractionEnabled = true
      self.videoView.isHidden = false
      self.imageView.isHidden = true
    }
  }
  
  func handleData(_ data: Data) {
    let type = item.mediaType
    if type.mediaGroup == .ImageType {
      self.unlockZoom()
      let image = UIImage.generateImage(fromType: type, withData: data)
      
      let desiredImageWidth = UIScreen.main.bounds.width - 16
      
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
      self.lockZoom()
      initPlayer()
    }
  }
  
  func initPlayer() {
    videoController = AVPlayerViewController()
    addChildViewController(videoController)

    let url = URL(string: "https://img.pr0gramm.com/\(item.image)")
    let videoPlayer = AVPlayer(url: url!)
    videoController.player = videoPlayer
    videoController.allowsPictureInPicturePlayback = true
  	setAudio()
    
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

    self.videoView.frame = CGRect(x: x, y: 75, width: desiredVideoWidth, height: desiredVideoHeight)
    self.videoController.view.frame = CGRect(origin: CGPoint.zero, size: self.videoView.frame.size)
    
    if self.settings.autoplay {
      self.videoView.isHidden = false
      self.imageView.isHidden = true

      DispatchQueue.main.async {
        self.videoView.addSubview(self.videoController.view)
        self.videoController.player!.play()
      }
    } else {
      self.videoView.isHidden = true
      self.imageView.isHidden = false
      
      self.videoController.view.isUserInteractionEnabled = false
      self.cachedItem = self.videoController.player!.currentItem

      self.videoController.player!.replaceCurrentItem(with: nil)

      let width = screenSize.width - 16
      let playView = UIImageView(image: #imageLiteral(resourceName: "playButton"))
      playView.frame.origin = CGPoint(x: width / 2 - playView.frame.width / 2, y: width / 2 - playView.frame.height / 2)
      playView.isUserInteractionEnabled = false
      imageView.addSubview(playView)
      
      DispatchQueue.main.async {
        self.imageView.image = UIImage(data: self.item.thumbData!)
     	 	self.imageView.setNeedsDisplay()
      }
    }
  }
  
  func updateScrollViewSize() {
    var contentRect = CGRect.zero
    for view in contentView.subviews {
      contentRect = contentRect.union(view.frame)
    }
    contentView.contentSize = CGSize(width: self.view.frame.size.width, height: contentRect.size.height)
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
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if self.isZoomed {
      return
    }
    
    let offsetTop = contentView.contentOffset.y
    if view.frame.minY > 0 || offsetTop < 0 {
      contentView.contentOffset.x = 0
      scrollView.contentOffset.y = 0
      self.view.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.minY-offsetTop), size: self.view.frame.size)
    }
    
    if view.frame.minY < 0 {
      view.frame.origin = CGPoint.zero
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
    let offsetThreshold: CGFloat = 50
    
    if offsetTop == 0 && offsetLeft != 0 {
      print(offsetLeft)
      if offsetLeft > offsetThreshold {
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
      } else if offsetLeft < -offsetThreshold {
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
  
  func lockZoom() {
    contentView.maximumZoomScale = 1
    contentView.minimumZoomScale = 1
  }
  
  func unlockZoom() {
    contentView.minimumZoomScale = 0.5;
    contentView.maximumZoomScale = 6.0;
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.imageView
  }
  
  func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    contentView.isDirectionalLockEnabled = false
  }
  
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    if contentView.zoomScale < 1 {
      contentView.setZoomScale(1, animated: true)
      contentView.isDirectionalLockEnabled = true
    }
  }

  func animateBack() {
    if !willClose && self.view.frame.minY != 0 {
      UIView.animate(withDuration: 0.3, animations: { () -> Void in
        self.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size)
      }) { (Finished) -> Void in
        self.isAnimating = false
      }
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
