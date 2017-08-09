//
//  SettingsStore.swift
//  pr0
//
//  Created by Björn Friedrichs on 29.07.17.
//  Copyright © 2017 Björn Friedrichs. All rights reserved.
//

import Foundation
import UIKit

final class SettingsStore {
  static let shared = SettingsStore()
  
  static let AUDIO_CHANGED = "audio_toggled"
  
  let storage = UserDefaults.standard
  
  let _width = UIScreen.main.bounds.width
  let _height = UIScreen.main.bounds.height
  
  var width: CGFloat {
    return _width
  }
  
  var height: CGFloat {
    return _height
  }

  private var _filter: Set<FlagStatus> = [.SFW]
  private var _promoted = false
  private var _autoplay = true
  private var _audio = true
  private var _loginCookie: HTTPCookie? = nil
  private var _logOffset = 0
  
  var filter: Set<FlagStatus> {
    get {
    	return _filter
    }
    set {
      let filterArray = newValue.map({ return $0.rawValue })
      storage.set(filterArray, forKey: "filter")
      storage.synchronize()
      _filter = newValue
    }
  }
  
  var promoted: Bool {
    get {
      return _promoted
    }
    set {
      storage.set(newValue, forKey: "promoted")
      storage.synchronize()
      _promoted = newValue
    }
  }
  
  var autoplay: Bool {
    get {
    	return _autoplay
    }
    set {
      storage.set(newValue, forKey: "autoplay")
      storage.synchronize()
      _autoplay = newValue
    }
  }
  
  var audio: Bool {
    get {
    	return _audio
    }
    set {
      NotificationCenter.default.post(name: Notification.Name(rawValue: SettingsStore.AUDIO_CHANGED), object: nil)
      storage.set(newValue, forKey: "audio")
      storage.synchronize()
      _audio = newValue
    }
  }
  
  var loginCookie: HTTPCookie? {
    get {
      return _loginCookie
    }
    set {
      if newValue != nil {
        storage.set(newValue!.properties, forKey: "loginCookie")
      } else {
        storage.set(nil, forKey: "loginCookie")
      }
      storage.synchronize()
      _loginCookie = newValue
    }
  }
  
  var logOffset: Int {
    get {
      return _logOffset
    }
    set {
      storage.set(newValue, forKey: "logOffset")
      storage.synchronize()
      _logOffset = newValue
    }
  }
  
  func generateOption() -> ItemOption {
    return ItemOption(flags: Array(self._filter), promoted: self._promoted)
  }
  
  private init() {
    
    let filterArray = storage.value(forKey: "filter") as? [Int] ?? [1]
    self._filter = Set<FlagStatus>(filterArray.map { FlagStatus(rawValue: $0) } as! [FlagStatus])

    self._promoted = storage.value(forKey: "promoted") as? Bool ?? true
    self._autoplay = storage.value(forKey: "autoplay") as? Bool ?? true
    self._audio = storage.value(forKey: "audio") as? Bool ?? true
    self._logOffset = storage.value(forKey: "logOffset") as? Int ?? 0
    
    let properties = storage.value(forKey: "loginCookie") as? [HTTPCookiePropertyKey: Any] ?? nil
    if properties != nil {
      HTTPCookieStorage.shared.setCookie(HTTPCookie(properties: properties!)!)
      CookieJar.shared.updateMeCookie()
    }
    
    
  }
	
}
