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
  
  func showTextAlertView(title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  otherButtonActions: [(() -> Void)?]?) {
    self.cancelButtonAction = cancelButtonAction
    self.otherButtonActions = otherButtonActions
    let alertView = createTextAlertView(title, message: message, cancelButtonTitle: cancelButtonTitle, cancelButtonAction:cancelButtonAction, otherButtonTitles: otherButtonTitles,  otherButtonActions: otherButtonActions)
    presentAlertView(alertView)
  }
  
  func showAlertView(title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  otherButtonActions: [(() -> Void)?]?) {
    self.cancelButtonAction = cancelButtonAction
    self.otherButtonActions = otherButtonActions
    let alertView = createAlertView(title, message: message, cancelButtonTitle: cancelButtonTitle, cancelButtonAction:cancelButtonAction, otherButtonTitles: otherButtonTitles,  otherButtonActions: otherButtonActions)
    presentAlertView(alertView)
  }

  func showAlertList(title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  indexActionHandler: ((AnyObject) -> Void)){
    let alertView = createListAlertView(title, message: message, cancelButtonTitle: cancelButtonTitle, cancelButtonAction: cancelButtonAction, otherButtonTitles: otherButtonTitles, indexActionHandler: indexActionHandler)
    presentAlertView(alertView)
  }
  
  func createListAlertView(title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  indexActionHandler: ((AnyObject) -> Void)) -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .Alert
    )
    
    let closure = { (index: Int) in
      { (action: UIAlertAction!) -> Void in
        indexActionHandler(index)
      }
    }


    if let otherButtonTitles = otherButtonTitles {
      for (index, otherButtonTitle) in otherButtonTitles.enumerate() {
        alert.addAction(UIAlertAction(title: otherButtonTitle, style: .Default, handler: closure(index)))
      }
    }
    
    let action = createUIAlertAction(cancelButtonTitle, style: .Default, handler: cancelButtonAction)
    alert.addAction(action)
    return alert
  }
  


  func createTextAlertView(title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  otherButtonActions: [(() -> Void)?]?) -> UIAlertController {
    let alertController = createAlertView(title, message: message, cancelButtonTitle: cancelButtonTitle, cancelButtonAction: cancelButtonAction, otherButtonTitles: otherButtonTitles, otherButtonActions: otherButtonActions)
    alertController.addTextFieldWithConfigurationHandler(configurationTextField)
    return alertController
  }
  
  func configurationTextField(inputTextField: UITextField!){
    if let aTextField = inputTextField {
      textField = aTextField
      textField?.keyboardType = .NumberPad
      textField?.accessibilityLabel = "textFieldInput"
    }
  }
  
  func createAlertView(title: String?, message: String?, cancelButtonTitle: String?, cancelButtonAction:(() -> Void)?, otherButtonTitles: [String]?,  otherButtonActions: [(() -> Void)?]?) -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .Alert
    )
    
    if let otherButtonTitles = otherButtonTitles {
      
      for (index, otherButtonTitle) in otherButtonTitles.enumerate() {
        createOtherButton(index, otherButtonTitle: otherButtonTitle, alertView: alert)
      }
    }
    
    let action = createUIAlertAction(cancelButtonTitle, style: .Default, handler: cancelButtonAction)
    alert.addAction(action)
    return alert
  }
  
  func createOtherButton(index: Int, otherButtonTitle: String?, alertView: UIAlertController) {
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
    
    let action = createUIAlertAction(otherButtonTitle!, style: .Default, handler: handler)
    alertView.addAction(action)
  }
  
  private func createUIAlertAction(title: String?, style: UIAlertActionStyle, handler: (() -> Void)?) -> UIAlertAction {
    return UIAlertAction(title: title!, style: style, handler: { action in
      handler?()
      return
    })
  }
  
  func presentAlertView(alertView: UIAlertController) {
    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)
  }
}