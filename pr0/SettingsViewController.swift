//
//  SettingsViewController.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, MultiSelectionSegmentedControlDelegate {
  
  @IBAction func topicChanged(_ sender: UISegmentedControl) {
    settings.promoted = sender.selectedSegmentIndex == 1 ? true : false
  }
  
  @IBAction func autoplayChanged(_ sender: UISegmentedControl) {
    settings.autoplay = sender.selectedSegmentIndex == 1 ? false : true
  }
  
  @IBOutlet var flagContainer: UIView!
  @IBOutlet var topicSelect: UISegmentedControl!
  @IBOutlet var autoPlaySelect: UISegmentedControl!

  var flagSelect : MultiSelectionSegmentedControl!
  var flagMapping = [FlagStatus.SFW, FlagStatus.NSFW, FlagStatus.NSFL]
  
  let settings = SettingsStore.sharedInstance
  
  override func viewDidLoad() {
		super.viewDidLoad()

    flagContainer.backgroundColor = nil
    flagSelect = MultiSelectionSegmentedControl(items: ["SFW", "NSFW", "NSFL"])
    flagSelect.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: flagContainer.frame.size)
    flagSelect.tintColor = Color.Highlight
    flagSelect.backgroundColor = Color.Back
    flagSelect.preserveOne = true
    flagSelect.delegate = self

    flagContainer.addSubview(flagSelect)
    
    topicSelect.selectedSegmentIndex = settings.promoted ? 1 : 0
    autoPlaySelect.selectedSegmentIndex = settings.autoplay ? 0 : 1
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    var flagIndices = [Int]()
    for f in settings.filter {
  		flagIndices.append(flagMapping.index(of: f)!)
    }
		flagSelect.selectedSegmentIndices = flagIndices
    flagSelect.font = UIFont.systemFont(ofSize: 13)
    flagSelect.highlightTextColor = Color.Back
  }
  
  func multiSelectionSegmentedControl(_ control: MultiSelectionSegmentedControl, selectedIndices indices: [Int]) {
    settings.filter.removeAll()
    for i in indices {
      settings.filter.insert(flagMapping[i])
    }
  }
}
