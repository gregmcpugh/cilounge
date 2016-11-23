//
//  SettingsViewController.swift
//  CircleCi
//
//  Created by Adrian Wu on 27/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  let refreshOptions:[String] =  ["5", "15", "30","60" ]
  lazy var alertViewManager: UIAlertControllerManager = {
    UIAlertControllerManager()
  }()
  
  @IBOutlet weak var RefreshButton: UIButton!

  @IBOutlet weak var AccessTokenTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Settings"
      RefreshButton.setTitle("Refresh rate: \(getRefreshRate())", for: UIControlState())
      AccessTokenTextField.text = "\(getCurrentAccessToken())"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
  
  @IBAction func refreshAction(_ sender: AnyObject) {
    alertViewManager.showAlertList("Select Refresh Rate", message: "", cancelButtonTitle: "Cancel", cancelButtonAction: nil, otherButtonTitles: refreshOptions) { index -> Void in
      let id = index as! Int
      let selectedTime = self.refreshOptions[id]
      saveRefreshRate(selectedTime)
      self.RefreshButton.setTitle("Refresh rate: \(selectedTime)", for: UIControlState())
     }
}
}

extension SettingsViewController:UITextFieldDelegate{
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

    if let text = textField.text{
      saveAccessToken(text)
    }
    
    return true
  }
}
