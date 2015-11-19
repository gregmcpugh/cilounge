//
//  Build.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation

public class Build: NSObject {

  public var authorDate: NSDate
  public var buildParametersData: NSData?
  public var compareURLString: String?
  public var buildID: String?
  public var urlString: String?
  public var dontBuild: String?
  public var isCanceled: NSNumber
  public var isInfrastructureFail: NSNumber
  public var isOpenSource: NSNumber
  public var isTimedout: NSNumber
  public var lifecycle: String?
  public var number: NSNumber
  public var parallelCount: NSNumber
  public var queuedAt: NSDate?
  public var startedAt: NSDate?
  public var status: String?
  public var stoppedAt: NSDate?
  public var timeMillis: NSNumber?
  public var why: String?
  public var branch: Branch?
  public var commits: NSSet?
  public var nodes: NSSet?
  public var project: Project?
  public var retries: NSSet?
  public var retryOf: Build?
  public var steps: NSSet?
  public var triggeredCommit: Commit?
  public var user: User?
  
  init(buildData: NSDictionary) {
    super.init()
  }

}
