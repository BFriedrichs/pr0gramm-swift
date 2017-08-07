//
//  UserLoginViewController.swift
//  pr0gramm
//
//  Created by Björn Friedrichs on 06.08.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

class UserLoginViewController: UIViewController {
  
  weak var userViewControllerDelegate: UserViewController?
  let api = API.sharedInstance
  
  @IBOutlet var keyboardViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var registerButton: UIButton!
  @IBOutlet var forgotButton: UIButton!
  
  @IBOutlet var errorMessage: UILabel!
  @IBOutlet var usernameField: UITextField!
  @IBOutlet var passwordField: UITextField!
  
  @IBAction func loginButtonPressed(_ sender: UIButton) {
    // TODO: simple client side check
    
    let name = usernameField.text!
    let pass = passwordField.text!
    
    guard name != "" && pass != "" else {
      showError(error: Error.EMPTY_LOGIN_FIELD)
      return
    }

    api.userService.login(withName: usernameField.text ?? "", password: passwordField.text ?? "", cb: { success in
      if self.api.userService.isLoggedIn {
        self.navigationController!.dismiss(animated: true, completion: {})
      } else {
        self.showError(error: Error.LOGIN_FAILED)
      }
    })
  }
  
  @IBAction func registerButtonPressed(_ sender: Any) {

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: .UIKeyboardWillShow, object: nil)
  }
  
  func showKeyboard(notification: Notification) {
    let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
    
    self.keyboardViewHeightConstraint.constant = keyboardSize.size.height
    UIView.animate(withDuration: 0.5, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  func cancel() {
    userViewControllerDelegate!.navigationController?.popToRootViewController(animated: false)
    self.navigationController!.dismiss(animated: true, completion: {
    })
  }
  
  func showError(error: String) {
    DispatchQueue.main.async {
      self.errorMessage.text = error
      self.errorMessage.isHidden = false
    }
  }
}
