//
//  UserViewController.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 07.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: UIViewController {
  
  let api = API.sharedInstance
  
  @IBAction func logoutButtonPressed(_ sender: Any) {
    api.userService.logout()
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  override func viewDidLoad() {
    if !api.userService.isLoggedIn {
      performSegue(withIdentifier: "LoginSegue", sender: self)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if !api.userService.isLoggedIn {
      self.dismiss(animated: true, completion: { 
        
      })
    }
  }
}
