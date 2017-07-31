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
  
  let api = API()
  
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
  	galleryPostLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    galleryPostLayout.minimumLineSpacing = 1.0
    galleryPostLayout.minimumInteritemSpacing = 1.0
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let option = settings.generateOption()
    
    if api.itemService.itemStorage.getFilteredContent(withOption: settings.generateOption()).count == 0 {
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
    print(api.itemService.itemStorage.getFilteredContent(withOption: settings.generateOption()).count)
    return api.itemService.itemStorage.getFilteredContent(withOption: settings.generateOption()).count
  }

  // make a cell for each cell index path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // get a reference to our storyboard cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GalleryPostCell
    
    cell.backgroundColor = UIColor.clear // make cell more visible in our example project

    let index = indexPath[1]
    let option = settings.generateOption()
    let posts = api.itemService.itemStorage.getFilteredContent(withOption: option)
    if posts.count >= index {
      let post = posts[index]

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
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if loadingNew {
      return
    }
    
    let viewHeight = scrollView.bounds.height
    let contentHeight = scrollView.contentSize.height
    let offsetTop = scrollView.contentOffset.y
    let offsetBottom = contentHeight - offsetTop - viewHeight
    
    if offsetBottom < viewHeight {
      let oldestItem = api.itemService.itemStorage.getOldestItem(withOptions: settings.generateOption())
      if oldestItem != nil {
        var newOption = settings.generateOption()
        newOption.older = settings.promoted ? oldestItem!.promoted : oldestItem!.id
        loadingNew = true
        
        api.itemService.getItems(withOptions: newOption, cb: { items in
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
      if let indexPaths = self.galleryView.indexPathsForSelectedItems {
        let indexPath = indexPaths[0]
        
        let cell = self.galleryView.cellForItem(at: indexPath) as! GalleryPostCell
        let segue = segue.destination as! SingleViewController
       	segue.initSize = cell.frame.applying(CGAffineTransform.init(translationX: 0, y: -galleryView.contentOffset.y))
        print(segue.initSize)
        segue.initImage = cell.postPreview.image
      }
    }
  }
}

