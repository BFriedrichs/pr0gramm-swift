//
//  GalleryViewController.swift
//  pr0
//
//  Created by Björn Friedrichs on 24.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import UIKit

typealias loadCheck = (id: Int64, isLoaded: Bool)

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  let api = API.sharedInstance
  
  let reuseIdentifier = "galleryPostCell"
  let padding : CGFloat = 3
  
  let settings = SettingsStore.sharedInstance
  
  @IBOutlet var galleryView: UICollectionView!
  @IBOutlet var galleryPostLayout: UICollectionViewFlowLayout!

  var loadingNew = false

  override func viewDidLoad() {
    super.viewDidLoad()
    
    galleryView.isPrefetchingEnabled = true
    galleryView.allowsMultipleSelection = false
    
    let size = view.frame.width / 3 - padding
    galleryPostLayout.itemSize = CGSize(width: size, height: size)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let option = settings.generateOption()
    
    if !api.itemStore.isCached(option: option) {
      api.itemService.getItems(withOptions: option, cb: { items in
        self.updateGallery()
      })
    }
  }
  
  func updateGallery() {
    DispatchQueue.main.async {
      print("reload gallery")
      self.galleryView.reloadData()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(api.itemStore.getFilteredContent(withOption: settings.generateOption()).count)
    return api.itemStore.getFilteredContent(withOption: settings.generateOption()).count
  }

  // make a cell for each cell index path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // get a reference to our storyboard cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GalleryPostCell
    
    cell.backgroundColor = UIColor.clear // make cell more visible in our example project

    let index = indexPath[1]
    let option = settings.generateOption()
    let posts = api.itemStore.getFilteredContent(withOption: option)
    if posts.count >= index {
      let post = posts[index]
			cell.item = post
      
      api.itemService.getItemThumb(forItem: post, cb: { imageData in
        let image = UIImage.init(data: imageData)
        
        DispatchQueue.main.async {
          cell.postPreview.image = image
        }
      })
    }
    
    cell.layer.shouldRasterize = true
    cell.layer.rasterizationScale = UIScreen.main.scale
		cell.backgroundColor = Color.Back
    
    return cell
  }
  
  // change background color when user touches cell
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.backgroundColor = Color.Highlight
  }
  
  // change background color back when user releases touch
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.backgroundColor = Color.Back
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if loadingNew {
      return
    }
    
    let offsetTop = scrollView.contentOffset.y
    
    if offsetTop < 0 {
      let newestItem = api.itemStore.itemInCache(forIndex: 0)
      
      if newestItem != nil {
        var newerOption = settings.generateOption()
        newerOption.setNewer(thanItem: newestItem!)
        loadingNew = true
        ActivityIndicator.show()
       	
        let count = api.itemStore.sizeOfCache()!
        
        api.itemService.getItems(withOptions: newerOption, cb: { items in
          ActivityIndicator.hide()
          
          let countNew = self.api.itemStore.sizeOfCache()!
          
          if count != countNew {
            self.updateGallery()
          }
          
          self.loadingNew = false
        })
      }
    }

  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if loadingNew {
      return
    }
    
    let viewHeight = scrollView.bounds.height
    let contentHeight = scrollView.contentSize.height
    let offsetTop = scrollView.contentOffset.y
    let offsetBottom = contentHeight - offsetTop - viewHeight
    
    if offsetBottom < viewHeight {
      let oldestItem = api.itemStore.getOldestItem(withOptions: settings.generateOption())
      
      if oldestItem != nil {
        var olderOption = settings.generateOption()
        olderOption.setOlder(thanItem: oldestItem!)
        loadingNew = true
        
        api.itemService.getItems(withOptions: olderOption, cb: { items in
          self.updateGallery()
          self.loadingNew = false
        })
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SingleViewSegue" {
      let cell = sender as! GalleryPostCell
      let segue = segue.destination as! SingleViewController
      segue.initSize = cell.frame.applying(CGAffineTransform.init(translationX: 0, y: -galleryView.contentOffset.y))
      segue.initImage = cell.postPreview.image
      segue.item = cell.item
    }
  }
}

