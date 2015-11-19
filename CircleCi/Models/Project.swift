//
//  Project.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Project: Mappable {

  var parallelCount: NSNumber?
  var repositoryName: String?
  var username: String?
  var urlString: String?
  var branches: NSSet?
  var builds: NSSet?
  var commits: NSSet?
  var projectID: String?
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    parallelCount <- map["parallelCount"]
    repositoryName <- map["repositoryName"]
    username <- map["username"]
    urlString <- map["urlString"]
    branches <- map["branches"]
    builds <- map["builds"]
    commits <- map["commits"]
    projectID <- map["projectID"]
  }
  
}
