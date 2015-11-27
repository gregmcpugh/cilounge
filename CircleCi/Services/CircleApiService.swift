//
//  CircleApiService.swift
//  CircleCi
//
//  Created by Adrian Wu on 20/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import Foundation
import ObjectMapper

let BASE_URL = "https://circleci.com/api/v1/"

enum CircleAPI {
  case RecenBuilds
  case RecentBuildProject(String,String)
  case RecentBuildBranch(String, String, String)
  case CancelBuild(String, String, String)
  case RetryBuild(String, String, String)
  case Projects
  var path : String {
    switch self {
    case RecenBuilds:                                        return BASE_URL + "recent-builds?circle-token=" +  getCurrentAccessToken()
    case RecentBuildProject(let user, let project):                    return BASE_URL + "project/" + user + "/" + project + "?circle-token=" + getCurrentAccessToken()
    case RecentBuildBranch(let user,let project, let branch):          return BASE_URL + "project/" + user + "/" + project  + "/tree/" + branch + "?circle-token=" +  getCurrentAccessToken()
    case CancelBuild(let user, let project,let buildNumber): return BASE_URL + "project/" + user + "/" + project + "/" + buildNumber + "/cancel?circle-token="  +  getCurrentAccessToken()
    case RetryBuild(let user, let project,let buildNumber): return BASE_URL + "project/" + user + "/" + project + "/" + buildNumber + "/retry?circle-token="  +  getCurrentAccessToken()
    case Projects:                                           return BASE_URL + "projects?circle-token=" + getCurrentAccessToken()
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
    if let httpResponse = response as? NSHTTPURLResponse {
      if httpResponse.statusCode == 401{
        failureCallback(NSError(domain: "Unauthorised", code: 401, userInfo: nil))
      }
    }
    else{
      if let jsonResult: NSArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray {
        successCallback(Mapper<Build>().mapArray(jsonResult)!)
      }
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

    if let httpResponse = response as? NSHTTPURLResponse {
      if httpResponse.statusCode == 401{
        failureCallback(NSError(domain: "Unauthorised", code: 401, userInfo: nil))
      }
    }
    else{
    if let jsonResult: NSArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray {
      let projects =   Mapper<Project>().mapArray(jsonResult)
      successCallback(projects!)
      }
    }
    if let error = error {
      failureCallback(error)
    }
  }
  task.resume()
}

func cancelBuild(build:Build, successCallback:Void ->() ,  failureCallback:NSError!->() ){
  if let username = build.username, reponame = build.reponame, buildNum = build.build_num{
    let url: NSURL = NSURL(string: CircleAPI.CancelBuild(username, reponame, buildNum.stringValue).path)!
    let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    request1.HTTPMethod = "POST"
    request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request1.setValue("application/json", forHTTPHeaderField: "Accept")
    let task  = NSURLSession.sharedSession().dataTaskWithRequest(request1){ data, response, error in
      if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode == 401{
          failureCallback(NSError(domain: "Unauthorised", code: 401, userInfo: nil))
        }
      }
      else{
        if let jsonResult: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary {
          if let outcome = jsonResult["outcome"]{
            if outcome as! String == "canceled"{
              successCallback()
            }
          }
          if let error = error {
            failureCallback(error)
          }
        }
      }
    }
    task.resume()
    
  }
  else{
    failureCallback(NSError(domain: "Information missing in model Sorry", code: 999, userInfo: nil))
  }
}



func rebuild(build:Build, successCallback:Void ->() ,  failureCallback:NSError!->() ){
  if let username = build.username, reponame = build.reponame, buildNum = build.build_num{
    let url: NSURL = NSURL(string: CircleAPI.RetryBuild(username, reponame, buildNum.stringValue).path)!
    let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    request1.HTTPMethod = "POST"
    request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request1.setValue("application/json", forHTTPHeaderField: "Accept")
    let task  = NSURLSession.sharedSession().dataTaskWithRequest(request1){ data, response, error in
      if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode == 401{
          failureCallback(NSError(domain: "Unauthorised", code: 401, userInfo: nil))
        }
      }
      else{
        if let jsonResult: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary {
          if let lifecycle = jsonResult["lifecycle"]{
            if lifecycle as! String == "queued"{
              successCallback()
            }
          }
          if let error = error {
            failureCallback(error)
          }
        }
      }
    }
    task.resume()
    
  }
  else{
    failureCallback(NSError(domain: "Information missing in model Sorry", code: 999, userInfo: nil))
  }
}

