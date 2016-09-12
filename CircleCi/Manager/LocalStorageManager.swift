//
//  LocalStorageManager.swift
//  CircleCi
//
//  Created by Adrian Wu on 27/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import Foundation

enum LocalStorageKey:String{
  case AccessToken              = "ACCESS_TOKEN"
  case RefreshRate              = "REFRESH_RATE"
}


func getRefreshRate() -> String {
  return getStringFromLocalStorage(LocalStorageKey.RefreshRate.rawValue) ?? "30"
}

func saveRefreshRate(rate:String){
  saveStringToLocalStorage(LocalStorageKey.RefreshRate.rawValue,value: rate)
}


func getCurrentAccessToken() -> String {
  return "af5180393c26adc087340e9bc5fb2d96405ef289"
//  return getStringFromLocalStorage(LocalStorageKey.AccessToken.rawValue) ?? ""
}

func saveAccessToken(accessToken:String){
  saveStringToLocalStorage(LocalStorageKey.AccessToken.rawValue,value: accessToken)
}

private func saveStringToLocalStorage(key:String, value:String){
  let defaults = NSUserDefaults.standardUserDefaults()
  defaults.setObject(value, forKey: key)
  defaults.synchronize()
}

private func getStringFromLocalStorage(key:String) -> String?{
  let defaults = NSUserDefaults.standardUserDefaults()
  return defaults.stringForKey(key)
}
