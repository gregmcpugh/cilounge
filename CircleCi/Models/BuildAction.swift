//
//  BuildAction.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation

public class BuildAction: NSObject {

  public var bashCommand: String?
  public var command: String?
  public var endedAt: NSDate?
  public var startedAt: NSDate?
  public var exitCode: NSNumber
  public var hasOutput: NSNumber
  public var index: NSNumber
  public var isCanceled: NSNumber
  public var isFailed: NSNumber
  public var isInfrastructureFail: NSNumber
  public var isParallel: NSNumber
  public var isTimedout: NSNumber
  public var isContinue: NSNumber
  public var isTruncated: NSNumber
  public var name: String?
  public var nodeIndex: NSNumber
  public var outputURLString: String?
  public var runTimeMillis: NSNumber
  public var source: String?
  public var status: String?
  public var type: String?
  public var buildStep: BuildStep
  public var buildActionID: String

  init(buildActionData: NSDictionary) {
    super.init()
    
    self.bashCommand = buildActionData["bashCommand"] as? String ?? ""
    self.command = buildActionData["command"] as? String ?? ""
    self.endedAt = buildActionData["endedAt"] as? NSDate ?? NSDate()
    self.startedAt = buildActionData["startedAt"] as? NSNumber ?? ""
    self.exitCode = buildActionData["exitCode"] as? NSNumber ?? ""
    self.hasOutput = buildActionData["hasOutput"] as? String ?? ""
    self.index = buildActionData["index"] as? String ?? ""
    self.isCanceled = buildActionData["isCanceled"] as? String ?? ""
    self.isFailed = buildActionData["isFailed"] as? String ?? ""
    self.isInfrastructureFail = buildActionData["isInfrastructureFail"] as? String ?? ""
    self.isParallel = buildActionData["isParallel"] as? String ?? ""
    self.isTimedout = buildActionData["isTimedout"] as? String ?? ""
    self.isContinue = buildActionData["isContinue"] as? String ?? ""
    self.isTruncated = buildActionData["isTruncated"] as? String ?? ""
    self.name = buildActionData["name"] as? String ?? ""
    self.nodeIndex = buildActionData["nodeIndex"] as? String ?? ""
    self.outputURLString = buildActionData["outputURLString"] as? String ?? ""
    self.runTimeMillis = buildActionData["runTimeMillis"] as? String ?? ""
    self.source = buildActionData["source"] as? String ?? ""
    self.status = buildActionData["status"] as? String ?? ""
    self.type = buildActionData["type"] as? String ?? ""
    self.buildStep = buildActionData["buildStep"] as? String ?? ""
    self.buildActionID = buildActionData["buildActionID"] as? String ?? ""
    
    
    
    
  }
  
}
