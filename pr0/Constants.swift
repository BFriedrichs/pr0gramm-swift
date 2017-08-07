//
//  URLService.swift
//  pr0gramm-api
//
//  Created by Björn Friedrichs on 29.07.17.
//
//

import Foundation

class Constants {
  
  private static let VERSION = "1.0.0"
  
  private static let PROT = "https://"
  
  private static let URL_STUB = "pr0gramm.com/"
  
  private static let THUMB_PREFIX = "thumb."
  private static let IMG_PREFIX = "img."
  
  static func getStandardUrl() -> String {
    return PROT + URL_STUB
  }
  
  static func getUserAgent() -> String {
  	return "pr0gramm-iphone/\(VERSION) (Swift 3)"
  }
  
  static func getApiUrl() -> String {
    return Constants.getStandardUrl() + "api/"
  }
  
  static func getThumbUrl() -> String {
    return PROT + THUMB_PREFIX + URL_STUB
  }

	static func getImgUrl() -> String {
  	return PROT + IMG_PREFIX + URL_STUB
  }
}
