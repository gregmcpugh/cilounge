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
  }
  
}
