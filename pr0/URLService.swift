//
//  URLService.swift
//  pr0gramm-api
//
//  Created by Björn Friedrichs on 29.07.17.
//
//

import Foundation

class URLService {
  static let PROT = "https://"
  static let URL_STUB = "pr0gramm.com/"
  static let API_URL = URLService.URL_STUB + "api/"
  
  static let THUMB_PREFIX = "thumb."
  static let IMG_PREFIX = "img."
  
  
  static var apiUrl: String {
    get {
      return PROT + API_URL
    }
  }
  
  static var standardUrl: String {
    get {
  		return PROT + URL_STUB
    }
  }
  
  static var thumbUrl: String {
    get {
      return PROT + THUMB_PREFIX + URL_STUB
    }
  }

	static var imgUrl: String {
    get {
      return PROT + IMG_PREFIX + URL_STUB
    }
  }
}
