//
//  Build.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Build: Mappable {
  
  var committer_date: NSDate?
  var build_num : NSNumber?
  var subject: String?
  var reponame :String?
  var build_url:String?
  var committer_name:String?
  var dontBuild: String?
  var timedout: Bool?
  var number: NSNumber?
  var queuedAt: NSDate?
  var startedAt: NSDate?
  var status: String?
  var build_time_millis: NSNumber?
  var branch:String?
  var lifecycle:String?
  var author_name:String?
  var why: String?
  var user: User?
  var retries:String?
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    author_name <- map["author_name"]
    timedout <- map["timedout"]
    lifecycle <- map["lifecycle"]
    branch <- map["branch"]
    committer_date        <- map["committer_date"]
    build_num <- map["build_num"]
    retries <- map["retries"]
    reponame <- map["reponame"]
    committer_name <- map["committer_name"]
    subject <- map["subject"]
    why <- map["why"]
    build_url <- map["build_url"]
    build_time_millis <- map["build_time_milliss"]
    user <- map["user"]
    subject <- map["subject"]
    status <- map["status"]
  }
  
  func statusColour() -> UIColor {
    
    if let switchStatus = status{
      switch switchStatus {
      case "running":
        return  UIColor(red: (55/255), green: (127/255), blue: (192/255), alpha: 1)
      case "success":
        return  UIColor(red: (57/255), green: (139/255), blue: (0/255), alpha: 1)
      case "canceled":
        return  UIColor(red: (119/255), green: (119/255), blue: (119/255), alpha: 1)
      case "failed":
        return  UIColor(red: (161/255), green: (44/255), blue: (40/255), alpha: 1)
      case "skipped":
        return  UIColor(red: (205/255), green: (76/255), blue: (0/255), alpha: 1)
      case "timedOut":
        return  UIColor(red: (161/255), green: (44/255), blue: (40/255), alpha: 1)
      case "fixed":
        return  UIColor(red: (57/255), green: (139/255), blue: (0/255), alpha: 1)
      case "not_run":
        return  UIColor(red: (119/255), green: (119/255), blue: (119/255), alpha: 1)
      default:
        return UIColor.blackColor()
      }
    }
    return UIColor.blackColor()
  }
}
