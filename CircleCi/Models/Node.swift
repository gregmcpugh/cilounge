//
//  Node.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation
import ObjectMapper
class Node: Mappable {
  
  var imageID: String?
  var port: NSNumber?
  var publicIPAddress: String?
  var sshEnabled: NSNumber?
  var username: String?
  var nodeID: String?
  var builds: NSSet?
  
  required init?(map: Map) {
    
  }
  
  
  func mapping(map: Map) {
    imageID <- map["imageID"]
    port  <- map["port"]
    publicIPAddress  <- map["publicIPAddress"]
    sshEnabled  <- map["sshEnabled"]
    username  <- map["username"]
    nodeID  <- map["nodeID"]
    builds  <- map["builds"]
  }
}
