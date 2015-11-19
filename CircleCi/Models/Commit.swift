//
//  Commit.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation

public class Commit: NSObject {
  
   public var body: String?
   public var date: NSDate?
   public var sha1: String?
   public var subject: String?
   public var urlString: String?
   public var author: User?
   public var builds: NSSet?
   public var committer: User?
   public var project: Project?
   public var triggeredBuilds: NSSet?
  
  init(commitData: NSDictionary) {
    super.init()
  }
}
