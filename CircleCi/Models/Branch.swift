//
//  Branch.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Branch: Mappable {

   var name: String?
   var builds: NSSet?
   var branchID: NSString?
   var project: Project?
   var pushers: NSSet?
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    name        <- map["name"]
    builds      <- map["builds"]
    branchID    <- map["branchID"]
    project     <- map["project"]
    pushers     <- map["pushers"]
  }
}
