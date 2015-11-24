//
//  CircleApiService.swift
//  CircleCi
//
//  Created by Adrian Wu on 20/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import Foundation
import ObjectMapper

let token = "af5180393c26adc087340e9bc5fb2d96405ef289"
let BASE_URL = "https://circleci.com/api/v1/"

enum CircleAPI {
  case RecenBuilds
  case RecentBuildProject(String,String)
  case RecentBuildBranch(String, String, String)
  case CancelBuild(String, String, String)
  case Projects
  var path : String {
    switch self {
    case RecenBuilds:                                        return BASE_URL + "recent-builds?circle-token=" + token
    case RecentBuildProject(let user, let project):                    return BASE_URL + "project/" + user + "/" + project + "?circle-token=" + token
    case RecentBuildBranch(let user,let project, let branch):          return BASE_URL + "project/" + user + "/" + project  + "/tree/" + branch + "?circle-token=" + token
    case CancelBuild(let user, let project,let buildNumber): return BASE_URL + "project/" + user + "/" + project + "/" + buildNumber + "/cancel?circle-token="  + token
    case Projects:                                           return BASE_URL + "projects?circle-token=" + token
    }
  }
}


func getBuildForProjects(userName:String?, projectName:String?, branch:String? ,successCallback:AnyObject ->() ,  failureCallback:NSError!->() ){
  
  var url: NSURL = NSURL(string: CircleAPI.RecenBuilds.path)!
  if let userName = userName , projectName = projectName, branch = branch{
     url  = NSURL(string: CircleAPI.RecentBuildBranch(userName, projectName, branch).path)!
  }
  else if let userName = userName , projectName = projectName {
     url  = NSURL(string: CircleAPI.RecentBuildProject(userName, projectName).path)!
  }
  
  let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
  request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request1.setValue("application/json", forHTTPHeaderField: "Accept")
  
  let task  = NSURLSession.sharedSession().dataTaskWithRequest(request1){ data, response, error in
    if let jsonResult: NSArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray {
      successCallback(Mapper<Build>().mapArray(jsonResult)!)
    }
    if let error = error {
      failureCallback(error)
    }
  }
  task.resume()

}

func getProjects(successCallback:AnyObject ->() ,  failureCallback:NSError!->() ){
  let url: NSURL = NSURL(string: CircleAPI.Projects.path)!
  let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
  request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request1.setValue("application/json", forHTTPHeaderField: "Accept")
  
  let task  = NSURLSession.sharedSession().dataTaskWithRequest(request1){ data, response, error in
    if let jsonResult: NSArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray {
      let projects =   Mapper<Project>().mapArray(jsonResult)
      successCallback(projects!)
    }
    if let error = error {
      failureCallback(error)
    }
  }
  task.resume()
}

func rebuild(build:Build, successCallback:AnyObject ->() ,  failureCallback:NSError!->() ){
  
}

func cancelBuild(build:Build, successCallback:AnyObject ->() ,  failureCallback:NSError!->() ){
  //https://circleci.com/api/v1/project/:username/:project/:build_num/cancel?circle-token=af5180393c26adc087340e9bc5fb2d96405ef289
}

