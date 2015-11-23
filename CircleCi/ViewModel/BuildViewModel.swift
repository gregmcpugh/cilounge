//
//  BuildViewModel.swift
//  CircleCi
//
//  Created by Adrian Wu on 20/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
protocol BuildViewModelProtocol:class{
  func reloadCollectionView()
}

class BuildViewModel{
  var projects:[Project]?
  var selectedProject:Project?
  lazy var alertViewManager: UIAlertControllerManager = {
    UIAlertControllerManager()
  }()
  weak var delgate:BuildViewModelProtocol?
  var builds:Array<Build>?

  func getData(){
    SVProgressHUD.showInfoWithStatus("LOADING JUST WAIT!!")
    getRecentBuildsAcrossAllProjects({ (response) -> () in
      SVProgressHUD.showSuccessWithStatus("OK ITS Finished")
      if let res = (response as? NSArray) {
        self.builds = res as? Array<Build>
        dispatch_async(dispatch_get_main_queue()){
          self.delgate?.reloadCollectionView()
        }
      }
      }) { (error) -> () in
        SVProgressHUD.showErrorWithStatus(error.localizedDescription)
    }
    getProjects({response -> () in
      self.projects = response as! [Project]
      }) { error -> () in
    }

  }
  
  func numberOfSectionsInCollectionView()->Int{
    return 1
  }
  
  func numberOfCellsInCollectionView() -> Int{
    return builds?.count ?? 0
  }
  
  func branchAction(){
    
    alertViewManager.showAlertView("Branch Selection", message: "Please Select branch", cancelButtonTitle: "Cancel", cancelButtonAction: nil, otherButtonTitles:["branch"], otherButtonActions: nil)
  }
  
  func projectAction(){
    alertViewManager.showAlertView("Project Selection", message: "Please Select Project", cancelButtonTitle: "Cancel", cancelButtonAction: nil, otherButtonTitles:getProjectsNames(), otherButtonActions: nil)

  }
  
  func didSelectCellAtIndexPath(indexPath:NSIndexPath){
    alertViewManager.showAlertView("TAKE CONTROL!!!!", message: "You have the power", cancelButtonTitle: "Cancel", cancelButtonAction: nil, otherButtonTitles:["Yes"], otherButtonActions:[rebuildAction])
  }
  
  func rebuildAction(){

  }
  
  func getProjectsNames()->[String]{
    var strArray = [String]()
    for projct in projects!{
      strArray.append(projct.reponame!)
    }
    return strArray
  }
}