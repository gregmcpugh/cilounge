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
  case recenBuilds
  case recentBuildProject(String,String)
  case recentBuildBranch(String, String, String)
  case cancelBuild(String, String, String)
  case retryBuild(String, String, String)
  case projects
  var path : String {
    switch self {
    case .recenBuilds:                                        return BASE_URL + "recent-builds?circle-token=" +  getCurrentAccessToken()
    case .recentBuildProject(let user, let project):                    return BASE_URL + "project/" + user + "/" + project + "?circle-token=" + getCurrentAccessToken()
    case .recentBuildBranch(let user,let project, let branch):          return BASE_URL + "project/" + user + "/" + project  + "/tree/" + branch + "?circle-token=" +  getCurrentAccessToken()
    case .cancelBuild(let user, let project,let buildNumber): return BASE_URL + "project/" + user + "/" + project + "/" + buildNumber + "/cancel?circle-token="  +  getCurrentAccessToken()
    case .retryBuild(let user, let project,let buildNumber): return BASE_URL + "project/" + user + "/" + project + "/" + buildNumber + "/retry?circle-token="  +  getCurrentAccessToken()
    case .projects:                                           return BASE_URL + "projects?circle-token=" + getCurrentAccessToken()
    }
  }
}

func getBuildForProjects(_ userName:String?, projectName:String?, branch:String? ,successCallback:@escaping ([Build]) ->() ,  failureCallback:@escaping (NSError!)->() ){
  
  var url: URL = URL(string: CircleAPI.recenBuilds.path)!
  if let userName = userName , let projectName = projectName, let branch = branch{
    url  = URL(string: CircleAPI.recentBuildBranch(userName, projectName, branch).path)!
  }
  else if let userName = userName , let projectName = projectName {
    url  = URL(string: CircleAPI.recentBuildProject(userName, projectName).path)!
  }
  
  var request1: URLRequest = URLRequest(url: url)
  request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request1.setValue("application/json", forHTTPHeaderField: "Accept")
  
  let task  = URLSession.shared.dataTask(with: request1, completionHandler: { data, response, error in
    if let httpResponse = response as? HTTPURLResponse {
      if httpResponse.statusCode == 401{
        failureCallback(NSError(domain: "Unauthorised", code: 401, userInfo: nil))
      }
      else if httpResponse.statusCode == 200{
        if let jsonResult: [[String: Any]] = try! JSONSerialization.jsonObject(with: data!, options:  .allowFragments) as? [[String: Any]] {
            let mapper = Mapper<Build>()
            let value = mapper.mapArray(JSONArray: jsonResult)!
            successCallback(value)
        }
      }
    }

    if let error = error {
      failureCallback(error as NSError!)
    }
  })
  task.resume()
  
}


func getProjects(_ successCallback:@escaping ([Project]) ->() ,  failureCallback:@escaping (NSError!)->() ){
  let url: URL = URL(string: CircleAPI.projects.path)!
  var request1: URLRequest = URLRequest(url: url)
  request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request1.setValue("application/json", forHTTPHeaderField: "Accept")
  
    let task  = URLSession.shared.dataTask(with: request1, completionHandler: {data, response, error in
    
    if let httpResponse = response as? HTTPURLResponse {
      
      if httpResponse.statusCode == 401{
        failureCallback(NSError(domain: "Unauthorised", code: 401, userInfo: nil))
      }
      if httpResponse.statusCode == 200{
        if let jsonResult: [[String: Any]] = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]] {
            let mapper = Mapper<Project>()
            let value = mapper.mapArray(JSONArray: jsonResult)!
          successCallback(value)
        }
      }
    }
    if let error = error {
      failureCallback(error as NSError!)
    }
  })
  task.resume()
}

func cancelBuild(_ build:Build, successCallback:@escaping (Void) ->() ,  failureCallback:@escaping (NSError!)->() ){
  if let username = build.username, let reponame = build.reponame, let buildNum = build.build_num{
    let url: URL = URL(string: CircleAPI.cancelBuild(username, reponame, buildNum.stringValue).path)!
    var request1: URLRequest = URLRequest(url: url)
    request1.httpMethod = "POST"
    request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request1.setValue("application/json", forHTTPHeaderField: "Accept")
    let task  = URLSession.shared.dataTask(with: request1, completionHandler: { data, response, error in
      if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 401{
          failureCallback(NSError(domain: "Unauthorised", code: 401, userInfo: nil))
        }
        if httpResponse.statusCode == 200{
          if let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
            if let outcome = jsonResult["outcome"]{
              if outcome as! String == "canceled"{
                successCallback()
              }
            }
            
          }
        }
      }
      
      if let error = error {
        failureCallback(error as NSError!)
      }
    })
    
    task.resume()
    
  }
  else{
    failureCallback(NSError(domain: "Information missing in model Sorry", code: 999, userInfo: nil))
  }
}



func rebuild(_ build:Build, successCallback:@escaping (Void) ->() ,  failureCallback:@escaping (NSError!)->() ){
  if let username = build.username, let reponame = build.reponame, let buildNum = build.build_num{
    let url: URL = URL(string: CircleAPI.retryBuild(username, reponame, buildNum.stringValue).path)!
    var request1: URLRequest = URLRequest(url: url)
    request1.httpMethod = "POST"
    request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request1.setValue("application/json", forHTTPHeaderField: "Accept")
    let task  = URLSession.shared.dataTask(with: request1, completionHandler: { data, response, error in
      if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 401{
          failureCallback(NSError(domain: "Unauthorised", code: 401, userInfo: nil))
        }
        if httpResponse.statusCode == 200{
          if let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
            if let lifecycle = jsonResult["lifecycle"]{
              if lifecycle as! String == "queued"{
                successCallback()
              }
            }
            
          }
        }
        
        if let error = error {
          failureCallback(error as NSError!)
        }
        
      }
    })
    task.resume()
    
  }
  else{
    failureCallback(NSError(domain: "Information missing in model Sorry", code: 999, userInfo: nil))
  }
}

