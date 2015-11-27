//
//  Extensions.swift
//  CircleCi
//
//  Created by Adrian Wu on 24/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//


extension Array where Element: Equatable {
  func arrayRemovingObject(object: Element) -> [Element] {
    return filter { $0 != object }
  }
  
  func itemExists<T where T : Equatable>(obj: T) -> Bool {
    return self.filter({$0 as? T == obj}).count > 0
  }
  
  func unique <T: Equatable> () -> [T] {
    var result = [T]()
    for item in self {
      if !result.contains(item as! T) {
        result.append(item as! T)
      }
    }
    return result
  }
}
