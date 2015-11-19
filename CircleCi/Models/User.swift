//
//  User.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {

  var email: String?
  var login: String?
  var name: String?
  var authedCommits: NSSet?
  var builds: NSSet?
  var commits: NSSet?
  var pushedBranches: NSSet?

  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
  email <- map["email"]
   login <- map["login"]
   name <- map["name"]
   authedCommits <- map["authedCommits"]
   builds <- map["builds"]
   commits <- map["commits"]
   pushedBranches <- map["pushedBranches"]
  }

}
