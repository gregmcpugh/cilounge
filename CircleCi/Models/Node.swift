//
//  Node.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation

public class Node: NSObject {

  public var imageID: String
  public var port: NSNumber
  public var publicIPAddress: String
  public var sshEnabled: NSNumber
  public var username: String
  public var nodeID: String
  public var builds: NSSet

  init(nodeData: NSDictionary) {
    super.init()
  }
}
