//
//  BuildStep.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation
import ObjectMapper


class BuildStep: Mappable {
  
   var index: NSNumber?
   var name: String?
   var actions: NSSet?
   var build: Build?
   var buildStepID: String?
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    index <- map["index"]
    name <- map["name"]
    actions <- map["actions"]
    build <- map["build"]
    buildStepID <- map["buildStepID"]
  }

}
