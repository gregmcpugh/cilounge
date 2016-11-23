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
  var username:String?
  var branches:NSDictionary?
  var reponame:String?
  init(dic:NSDictionary){ 
  }
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    username <- map["username"]
    branches <- map["branches"]
    reponame <- map["reponame"]
  }
  
  func getBrancheNames()->[String]{
    return branches?.allKeys as! [String]
  }
}
