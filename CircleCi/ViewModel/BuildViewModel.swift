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
  func reloadButtons(projectName:String, branchName:String)
}

class BuildViewModel{
  var projects:[Project]?
  var selectedProject:Project?
  var selectedBranchName:String?
  
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
    if let selectedProject = selectedProject{
      alertViewManager.showAlertList("Branch Selection", message: "Please Select branch", cancelButtonTitle: "Cancel", cancelButtonAction:{ () -> Void in
        self.selectedProject = nil
        self.selectedBranchName = nil
        self.delgate?.reloadButtons( "Project", branchName:"Branch")
        }, otherButtonTitles:  selectedProject.getBrancheNames(), indexActionHandler: { index in
        let id = index as! Int
        var branches = self.selectedProject?.getBrancheNames()
        self.selectedBranchName = branches![id] as String
        self.delgate?.reloadButtons( self.selectedProject?.reponame ?? "Project", branchName: self.selectedBranchName ?? "Branch")
      })
    }
    else{
      alertViewManager.showAlertView("No project selected", message: "please select project first before branch", cancelButtonTitle: "Cancel", cancelButtonAction: nil, otherButtonTitles: nil, otherButtonActions: nil)
      }
  }
  
  
  func projectAction(){

    alertViewManager.showAlertList("Branch Selection", message: "Please Select Project", cancelButtonTitle: "Cancel", cancelButtonAction: { () -> Void in
      self.selectedProject = nil
      self.selectedBranchName = nil
      self.delgate?.reloadButtons( "Project", branchName:"Branch")
      }, otherButtonTitles:getProjectsNames(), indexActionHandler: { index in
        let id = index as! Int
        self.selectedProject = self.projects?[id]
        self.delgate?.reloadButtons( self.selectedProject?.reponame ?? "Project", branchName: self.selectedBranchName ?? "Branch")    })

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