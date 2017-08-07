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
  @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet var commentView: UIView!
  @IBOutlet var commentViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet var infoView: UIView!
  
  @IBOutlet var tagView: UIView!
  @IBOutlet var tagViewHeightConstraint: NSLayoutConstraint!
  
  var initSize: CGRect!
  var initImage: UIImage!
  var item: Item!

  let settings = SettingsStore.sharedInstance
  
  var willClose = false
  var isAnimating = false
  
  var isZoomed: Bool {
    return contentView.zoomScale != CGFloat(1)
  }
  
  var videoController: AVPlayerViewController!
  var cachedItem: AVPlayerItem?
  var isVideo = false
  var videoPlayButton = UIImageView(image: #imageLiteral(resourceName: "playButton"))
  
  let api = API.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.hidesBackButton = true
    
    contentView.decelerationRate = UIScrollViewDecelerationRateFast
    contentView.isDirectionalLockEnabled = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(setAudio), name: Notification.Name(rawValue: SettingsStore.AUDIO_CHANGED), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateCommentSection), name: Notification.Name(rawValue: "comment"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateTagSection), name: Notification.Name(rawValue: "tag"), object: nil)
  
  	updateChildViewControllers()
  }
  
  func updateChildViewControllers() {
    for controller in self.childViewControllers {
      controller.viewDidLoad()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self)
  }
  
  func updateCommentSection() {
    DispatchQueue.main.async {
      self.commentViewHeightConstraint.constant = self.commentView.subviews[0].subviews[0].frame.height
      self.updateViewConstraints()
      
      print("comment height container: \(self.commentViewHeightConstraint.constant)")
    }
  }
  
  func updateTagSection() {
    DispatchQueue.main.async {
      self.tagViewHeightConstraint.constant = self.tagView.subviews[0].subviews[0].frame.height
      self.updateViewConstraints()
      
      print("tag height container: \(self.tagViewHeightConstraint.constant)")
    }
  }
  
  func setAudio() {
    if videoController != nil && videoController!.player != nil {
      videoController.player!.isMuted = !settings.audio
    }
  }
  
  func tappedVideoThumb(sender: UITapGestureRecognizer) {
    print("tapped video")
    if isVideo {
      guard videoController.player!.currentItem == nil else {
        return
      }

      videoPlayButton.removeFromSuperview()
      DispatchQueue.main.async {
        self.videoController.player!.replaceCurrentItem(with: self.cachedItem)
        self.setVideo()
        self.videoController.player!.play()
        self.cachedItem = nil
        self.imageView.image = nil
      }
    }
  }
  
  func handleData(_ data: Data) {
    let type = item.mediaType
    if type.mediaGroup == .ImageType {
      self.isVideo = false
      
      self.unlockZoom()
      let image = UIImage.generateImage(fromType: type, withData: data)
      let aspect = image.size.height / image.size.width
      let desiredImageWidth = settings.width - 16

      //imageView.translatesAutoresizingMaskIntoConstraints = false
      
      DispatchQueue.main.async {
        self.imageView.image = image
        self.imageViewHeightConstraint.constant = desiredImageWidth * aspect
        self.imageView.setNeedsDisplay()
      }
    } else if type.mediaGroup == .VideoType {
      self.isVideo = true
      
      self.lockZoom()
      initPlayer()
    }
  }
  
  func setVideo() {
    let size = videoController.player!.currentItem!.asset.tracks(withMediaType: AVMediaTypeVideo)[0].naturalSize
    let aspect = size.height / size.width
    
    let screenSize = UIScreen.main.bounds
    
    var desiredVideoWidth = screenSize.width - 16
    var desiredVideoHeight = desiredVideoWidth * aspect
    
    if screenSize.height - 103 < desiredVideoHeight {
      desiredVideoHeight -= 103
      desiredVideoWidth = desiredVideoHeight / aspect
    }


    DispatchQueue.main.async {
      self.imageViewHeightConstraint.constant = desiredVideoHeight
      self.videoController.view.frame = CGRect(origin: CGPoint.zero, size: self.imageView.frame.size)
      
      self.imageView.addSubview(self.videoController.view)
    }

    videoController.player!.play()
  }
  
  func initPlayer() {
    videoController = AVPlayerViewController()
    addChildViewController(videoController)

    let url = URL(string: "https://img.pr0gramm.com/\(item.image)")
    let videoPlayer = AVPlayer(url: url!)
    videoController.player = videoPlayer
  	setAudio()
    
    if self.settings.autoplay {
      setVideo()
    } else {
      cachedItem = videoController.player!.currentItem

      videoController.player!.replaceCurrentItem(with: nil)

      let width = settings.width - 16
      videoPlayButton.frame.origin = CGPoint(x: width / 2 - videoPlayButton.frame.width / 2, y: width / 2 - videoPlayButton.frame.height / 2)
      videoPlayButton.isUserInteractionEnabled = false
      imageView.addSubview(videoPlayButton)
      
      let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.tappedVideoThumb(sender:)))
      imageView.addGestureRecognizer(gesture)
      
      api.itemService.getItemThumb(forItem: self.item, cb: { data in
        DispatchQueue.main.async {
          self.imageView.image = UIImage(data: data)
          self.imageView.setNeedsDisplay()
          
          self.imageViewHeightConstraint.constant = width
        }
      })
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
      
      cachedItem = nil
      videoController.removeFromParentViewController()
    }
  }
  
  // MARK: Scroll
  
  var oldX: CGFloat = 0
  var oldY: CGFloat = 0
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if self.isZoomed {
      return
    }
    
    let offsetTop = contentView.contentOffset.y
		
    // only scroll one direction
    if offsetTop != oldY {
      if view.frame.minY > 0 || offsetTop < 0 {
        scrollView.contentOffset.y = 0
        self.view.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.minY-offsetTop), size: self.view.frame.size)
      }
      
      if view.frame.minY < 0 {
        view.frame.origin = CGPoint.zero
      }
      contentView.contentOffset.x = oldX
    }
    
    oldX = contentView.contentOffset.x
		oldY = contentView.contentOffset.y
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
        self.performShow(withOffset: 1)
        
      } else if offsetLeft < -offsetThreshold {
        print("pulled to right")
        self.performShow(withOffset: -1)
      }
    } else if offsetTop > self.initSize!.height {
      print("go back")
      willClose = true
      
      performSegue(withIdentifier: "GalleryViewSegue", sender: self)
    } else {
      animateBack()
    }
  }
  
  func performShow(withOffset offset: Int) {
    ActivityIndicator.show()
    
    if offset > 0 {
      api.itemService.getNextItem(after: self.item, cb: { item in
        if item != nil {
          DispatchQueue.main.async {
            self.performReset(withNewItem: item!, toLeft: false)
          }
        } else {
          ActivityIndicator.hide()
          Dialog.noOlderItem(self)
        }
      })
    } else {
      api.itemService.getPreviousItem(before: self.item, cb: { item in
        if item != nil {
          DispatchQueue.main.async {
            self.performReset(withNewItem: item!, toLeft: true)
          }
        } else {
          ActivityIndicator.hide()
          Dialog.noNewerItem(self)
        }
      })
    }
  }
  
  func resetView() {
    imageView.image = nil
    for sub in imageView.subviews {
      sub.removeFromSuperview()
    }
    
    contentView.setContentOffset(CGPoint.zero, animated: false)
    //imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: settings.width - 16, height: settings.width - 16))
  }
  
  func performReset(withNewItem item: Item, toLeft: Bool) {
    
    cleanupVideo(removeFromView: true)
    
    // TODO: exclude top bar from screenshot
		ActivityIndicator.hide()
    let screenshot = captureScreen()
    ActivityIndicator.show()
  
    let copy = UIImageView(image: screenshot!)
    
   	//let copy = contentView.deepCopy__EXPENSIVE()

    let screenWidth = settings.width
    let x = toLeft ? -screenWidth : screenWidth
    
    contentView.frame.origin = CGPoint(x: x, y: 0)
    view.addSubview(copy)
    self.item = item
    
    resetView()
    updateChildViewControllers()
    
    api.itemService.getItemContent(forItem: item, cb: { data in
      self.handleData(data)
      ActivityIndicator.hide()
    })
    
    UIView.animate(withDuration: 0.3, animations: {
      copy.frame.origin = CGPoint(x: -x, y: 0)
      self.contentView.frame.origin = CGPoint.zero
    }) { finished in
      copy.removeFromSuperview()
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
  
  // MARK: Zoom
  
  func showAll() {
    self.infoView.isHidden = false
    self.tagView.isHidden = false
    self.commentView.isHidden = false
  }
  
  func hideAll() {
    self.infoView.isHidden = true
    self.tagView.isHidden = true
    self.commentView.isHidden = true
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
    hideAll()
  }
  
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    if contentView.zoomScale < 1 {
      contentView.setZoomScale(1, animated: true)
      contentView.isDirectionalLockEnabled = true
      // contentSize resets on zoom ...
      contentView.contentSize = self.view.subviews[0].subviews[0].frame.size
      showAll()
    }
  }

}
