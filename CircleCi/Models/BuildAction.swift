//
//  BuildAction.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation

import ObjectMapper

class BuildAction: Mappable {

  var bashCommand: String?
  var command: String?
  var endedAt: NSDate?
  var startedAt: NSDate?
  var exitCode: NSNumber?
  var hasOutput: NSNumber?
  var index: NSNumber?
  var isCanceled: NSNumber?
  var isFailed: NSNumber?
  var isInfrastructureFail: NSNumber?
  var isParallel: NSNumber?
  var isTimedout: NSNumber?
  var isContinue: NSNumber?
  var isTruncated: NSNumber?
  var name: String?
  var nodeIndex: NSNumber?
  var outputURLString: String?
  var runTimeMillis: NSNumber?
  var source: String?
  var status: String?
  var type: String?
  var buildStep: BuildStep?
  var buildActionID: String?

  required init?(_ map: Map) {
    
  }

  func mapping(map: Map) {
    bashCommand <- map["bashCommand"]
    command <- map["command"]
    endedAt <- map["endedAt"]
    startedAt <- map["startedAt"]
    exitCode  <- map["exitCode"]
    hasOutput  <- map["hasOutput"]
    index  <- map["index"]
    isCanceled  <- map["isCanceled"]
    isFailed  <- map["isFailed"]
    isInfrastructureFail  <- map["isInfrastructureFail"]
    isParallel  <- map["isParallel"]
    isTimedout  <- map["isTimedout"]
    isContinue  <- map["isContinue"]
    isTruncated  <- map["isTruncated"]
    name  <- map["name"]
    nodeIndex  <- map["nodeIndex"]
    outputURLString  <- map["outputURLString"]
    runTimeMillis  <- map["runTimeMillis"]
    source  <- map["source"]
    status  <- map["status"]
    type  <- map["type"]
    buildStep  <- map["buildStep"]
    buildActionID  <- map["buildActionID"]
  }
  
}
