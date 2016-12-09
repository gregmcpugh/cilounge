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

func saveRefreshRate(_ rate:String){
  saveStringToLocalStorage(LocalStorageKey.RefreshRate.rawValue,value: rate)
}


func getCurrentAccessToken() -> String {
  return getStringFromLocalStorage(LocalStorageKey.AccessToken.rawValue) ?? ""
}

func saveAccessToken(_ accessToken:String){
  saveStringToLocalStorage(LocalStorageKey.AccessToken.rawValue,value: accessToken)
}

private func saveStringToLocalStorage(_ key:String, value:String){
  let defaults = UserDefaults.standard
  defaults.set(value, forKey: key)
  defaults.synchronize()
}

private func getStringFromLocalStorage(_ key:String) -> String?{
  let defaults = UserDefaults.standard
  return defaults.string(forKey: key)
}
