//
//  UIAlertControllerManger.swift
//  Collect_iOS
//
//  Created by Greg Pugh on 28/05/2015.
//  Copyright (c) 2015 Marks and Spencer PLC. All rights reserved.
//

import UIKit
class UIAlertControllerManager: NSObject {

  var textField:UITextField?
  var cancelButtonAction: (() -> Void)?
  var otherButtonActions: [(() -> Void)?]?
  
  func showTextAlertView(_ title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  otherButtonActions: [(() -> Void)?]?) {
    self.cancelButtonAction = cancelButtonAction
    self.otherButtonActions = otherButtonActions
    let alertView = createTextAlertView(title, message: message, cancelButtonTitle: cancelButtonTitle, cancelButtonAction:cancelButtonAction, otherButtonTitles: otherButtonTitles,  otherButtonActions: otherButtonActions)
    presentAlertView(alertView)
  }
  
  func showAlertView(_ title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  otherButtonActions: [(() -> Void)?]?) {
    self.cancelButtonAction = cancelButtonAction
    self.otherButtonActions = otherButtonActions
    let alertView = createAlertView(title, message: message, cancelButtonTitle: cancelButtonTitle, cancelButtonAction:cancelButtonAction, otherButtonTitles: otherButtonTitles,  otherButtonActions: otherButtonActions)
    presentAlertView(alertView)
  }

  func showAlertList(_ title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  indexActionHandler: @escaping ((AnyObject) -> Void)){
    let alertView = createListAlertView(title, message: message, cancelButtonTitle: cancelButtonTitle, cancelButtonAction: cancelButtonAction, otherButtonTitles: otherButtonTitles, indexActionHandler: indexActionHandler)
    presentAlertView(alertView)
  }
  
  func createListAlertView(_ title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  indexActionHandler: @escaping ((AnyObject) -> Void)) -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    let closure = { (index: Int) in
      { (action: UIAlertAction!) -> Void in
        indexActionHandler(index as AnyObject)
      }
    }


    if let otherButtonTitles = otherButtonTitles {
      for (index, otherButtonTitle) in otherButtonTitles.enumerated() {
        alert.addAction(UIAlertAction(title: otherButtonTitle, style: .default, handler: closure(index)))
      }
    }
    
    let action = createUIAlertAction(cancelButtonTitle, style: .default, handler: cancelButtonAction)
    alert.addAction(action)
    return alert
  }
  


  func createTextAlertView(_ title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  otherButtonActions: [(() -> Void)?]?) -> UIAlertController {
    let alertController = createAlertView(title, message: message, cancelButtonTitle: cancelButtonTitle, cancelButtonAction: cancelButtonAction, otherButtonTitles: otherButtonTitles, otherButtonActions: otherButtonActions)
    alertController.addTextField(configurationHandler: configurationTextField)
    return alertController
  }
  
  func configurationTextField(_ inputTextField: UITextField!){
    if let aTextField = inputTextField {
      textField = aTextField
      textField?.keyboardType = .numberPad
      textField?.accessibilityLabel = "textFieldInput"
    }
  }
  
  func createAlertView(_ title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  otherButtonActions: [(() -> Void)?]?) -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    if let otherButtonTitles = otherButtonTitles {
      
      for (index, otherButtonTitle) in otherButtonTitles.enumerated() {
        createOtherButton(index, otherButtonTitle: otherButtonTitle, alertView: alert)
      }
    }
    
    let action = createUIAlertAction(cancelButtonTitle, style: .default, handler: cancelButtonAction)
    alert.addAction(action)
    return alert
  }
  
  func createOtherButton(_ index: Int, otherButtonTitle: String?, alertView: UIAlertController) {
    if otherButtonTitle == nil {
      return
    }

    var handler: (() -> Void)?
    if let otherButtonActions = self.otherButtonActions
    {
      if index <= otherButtonActions.count {
        handler = otherButtonActions[index]
      }
    }
    
    let action = createUIAlertAction(otherButtonTitle!, style: .default, handler: handler)
    alertView.addAction(action)
  }
  
  fileprivate func createUIAlertAction(_ title: String?, style: UIAlertActionStyle, handler: (() -> Void)?) -> UIAlertAction {
    return UIAlertAction(title: title!, style: style, handler: { action in
      handler?()
      return
    })
  }
  
  func presentAlertView(_ alertView: UIAlertController) {
    UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
  }
}
