//
//  Build.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class Build: Mappable {
  
 var authorDate: NSDate?
 var buildParametersData: NSData?
 var compareURLString: String?
 var buildID: String?
 var urlString: String?
 var dontBuild: String?
 var isCanceled: NSNumber?
 var isInfrastructureFail: NSNumber?
 var isOpenSource: NSNumber?
 var isTimedout: NSNumber?
 var lifecycle: String?
 var number: NSNumber?
 var parallelCount: NSNumber?
 var queuedAt: NSDate?
 var startedAt: NSDate?
 var status: String?
 var stoppedAt: NSDate?
 var timeMillis: NSNumber?
 var why: String?
 var branch: Branch?
 var commits: NSSet?
 var nodes: NSSet?
 var project: Project?
 var retries: NSSet?
 var retryOf: Build?
 var steps: NSSet?
 var triggeredCommit: Commit?
 var user: User?
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    authorDate        <- map["authorDate"]
  }

}
