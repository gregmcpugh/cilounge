//
//  User.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation

public class User: NSObject {

   public var email: String?
   public var login: String?
   public var name: String?
   public var authedCommits: NSSet?
   public var builds: NSSet?
   public var commits: NSSet?
   public var pushedBranches: NSSet?

  init(userData: NSDictionary) {
    super.init()
  }
}
