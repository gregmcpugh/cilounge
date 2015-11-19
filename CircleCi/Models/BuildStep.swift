//
//  BuildStep.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation


public class BuildStep: NSObject {
  
  public var index: NSNumber
  public var name: String
  public var actions: NSSet?
  public var build: Build
  public var buildStepID: String
  
  init(buildStepData: NSDictionary) {
    super.init()
  }
}
