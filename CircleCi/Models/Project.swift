//
//  Project.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation

public class Project: NSObject {

   public var parallelCount: NSNumber?
   public var repositoryName: String?
   public var username: String?
   public var urlString: String?
   public var branches: NSSet?
   public var builds: NSSet?
   public var commits: NSSet?
   public var projectID: String?

  init(projectData: NSDictionary) {
    super.init()
  }
}
