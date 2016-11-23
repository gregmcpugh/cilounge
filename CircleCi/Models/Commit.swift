//
//  Commit.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Commit: Mappable {
  
 var body: String?
 var date: Date?
 var sha1: String?
 var subject: String?
 var urlString: String?
 var author: User?
 var builds: NSSet?
 var committer: User?
 var project: Project?
 var triggeredBuilds: NSSet?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    body  <- map["body"]
   date <- map["date"]
   sha1 <- map["sha1"]
   subject <- map["subject"]
   urlString <- map["urlString"]
   author <- map["author"]
   builds <- map["builds"]
   committer <- map["committer"]
   project <- map["project"]
   triggeredBuilds <- map["triggeredBuilds"]
  }
}
