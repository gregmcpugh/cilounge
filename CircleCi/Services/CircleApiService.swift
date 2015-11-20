//
//  CircleApiService.swift
//  CircleCi
//
//  Created by Adrian Wu on 20/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import Foundation
import ObjectMapper

let path = "https://circleci.com/api/v1/recent-builds?circle-token=af5180393c26adc087340e9bc5fb2d96405ef289&limit=50&offset=5"


func getRecentBuildsAcrossAllProjects(path:String, successCallback:AnyObject ->() ,  failureCallback:NSError!->() ) {
  
  let url: NSURL = NSURL(string: path)!
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

func cancelBuild(build:Build, successCallback:AnyObject ->() ,  failureCallback:NSError!->() ){
  
//  let url: NSURL = NSURL(string: path)!
//  let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
//  request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
//  request1.setValue("application/json", forHTTPHeaderField: "Accept")
//  
//
//  
//  let task  = NSURLSession.sharedSession().dataTaskWithRequest(request1){ data, response, error in
//    if let jsonResult: NSArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray {
//      successCallback(Mapper<Build>().mapArray(jsonResult)!)
//    }
//    if let error = error {
//      failureCallback(error)
//    }
//  }
//  task.resume()

  //https://circleci.com/api/v1/project/:username/:project/:build_num/cancel?circle-token=af5180393c26adc087340e9bc5fb2d96405ef289
}



//POST: /project/:username/:project/:build_num/cancel

