//
//  ShowLoginSegue.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 07.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class ShowLoginSegue: UIStoryboardSegue {
  override func perform() {
    let destination = (self.destination as! UserLoginViewController)
    let source = (self.source as! UserViewController)
    
    destination.modalPresentationStyle = .popover
    
    let nav = UINavigationController(rootViewController: destination)
    nav.modalPresentationStyle = .popover
    nav.navigationBar.barStyle = .blackTranslucent
    nav.navigationBar.tintColor = Color.Highlight
    nav.modalPresentationStyle = .popover
    
    let button = UIBarButtonItem(title: "Abbrechen", style: .plain, target: destination, action: #selector(UserLoginViewController.cancel))
    destination.navigationItem.rightBarButtonItem = button
    destination.userViewControllerDelegate = source
    
    source.present(nav, animated: true, completion: {
      
    })
  }
}
