//
//  Branch.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation


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
  
//  init(branchData: NSDictionary) {
//    super.init()
//    
//    self.name = branchData["name"] as? String ?? ""
//    self.builds = branchData["builds"] as? NSSet ?? NSSet()
//    self.branchID = branchData["branchID"] as? NSString ?? ""
//    self.project = branchData["project"] as? Project ?? Project()
//    self.pushers = branchData["pushers"] as? NSSet ?? NSSet()
//    
//  }
}
