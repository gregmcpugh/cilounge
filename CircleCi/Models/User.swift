//
//  User.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 11/1/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {

  var email: String?
  var login: String?
  var is_user:Bool?
  required init?(_ map: Map) {
  }
  
  func mapping(map: Map) {
    email <- map["email" , nested:true]
    login <- map["login"  , nested:true]
    is_user <- map["is_user", nested:true]
  }

}
