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
  var selectedBuild:Build?
  var runningBuilds:[Build]?
  var speakerOn:Bool = false

  
  lazy var alertViewManager: UIAlertControllerManager = {
    UIAlertControllerManager()
  }()
  weak var delgate:BuildViewModelProtocol?
  var builds:Array<Build>?
  
  func getData(){
    getAllBuilds()
  }
  
  func getAllBuilds() {
    SVProgressHUD.showWithStatus("ITS LOADING!!! GET OVER IT")
    getBuildForProjects(selectedProject?.username, projectName: selectedProject?.reponame, branch: selectedBranchName, successCallback: { (response) -> () in
      SVProgressHUD.showSuccessWithStatus("OK ITS Finished")
      if let res = (response as? NSArray) {
        self.builds = res as? Array<Build>
        dispatch_async(dispatch_get_main_queue()){
          self.delgate?.reloadCollectionView()
        }
        getProjects({response -> () in
          self.projects = response as! [Project]
          }) { error -> () in
        }
      }
      }) { (error) -> () in
        dispatch_async(dispatch_get_main_queue()){
        SVProgressHUD.dismiss()
          self.alertViewManager.showAlertView("Error", message: error.localizedDescription, cancelButtonTitle: "Ok", cancelButtonAction: nil, otherButtonTitles: nil, otherButtonActions: nil)
        }
    }
  }
  
  func speakerToggle() -> String{
    speakerOn = !speakerOn
    if speakerOn{
      return "speaker_on"
    }
    return "speaker_off"
  }

  func checkPreviousBuildStatus(newBuilds:[Build]){
    
  }
  
  func numberOfSectionsInCollectionView()->Int{
    return 1
  }
  
  func numberOfCellsInCollectionView() -> Int{
    return builds?.count ?? 0
  }
  
  func branchAction(){
    if let selectedProject = selectedProject{
      alertViewManager.showAlertList("Branch Selection", message: "Please Select branch", cancelButtonTitle: "All branches", cancelButtonAction:{ () -> Void in
        self.selectedProject = nil
        self.selectedBranchName = nil
        self.delgate?.reloadButtons( self.selectedProject?.reponame ?? "Project" , branchName:"Branch")
        self.getData()
        }, otherButtonTitles:  selectedProject.getBrancheNames(), indexActionHandler: { index in
          let id = index as! Int
          var branches = self.selectedProject?.getBrancheNames()
          self.selectedBranchName = branches![id] as String
          self.delgate?.reloadButtons( self.selectedProject?.reponame ?? "Project", branchName: self.selectedBranchName ?? "Branch")
          self.getData()
      })
    }
    else{
      alertViewManager.showAlertView("No project selected", message: "please select project first before branch", cancelButtonTitle: "Cancel", cancelButtonAction: nil, otherButtonTitles: nil, otherButtonActions: nil)
    }
  }
  
  
  func projectAction(){
    
    alertViewManager.showAlertList("Branch Selection", message: "Please Select Project", cancelButtonTitle: "All Projects", cancelButtonAction: { () -> Void in
      self.selectedProject = nil
      self.selectedBranchName = nil
      self.delgate?.reloadButtons( "Project", branchName:"Branch")
      self.getData()
      }, otherButtonTitles:getProjectsNames(), indexActionHandler: { index in
        let id = index as! Int
        self.selectedProject = self.projects?[id]
        self.delgate?.reloadButtons( self.selectedProject?.reponame ?? "Project", branchName: self.selectedBranchName ?? "Branch")
        self.getData()
    })
    
    
  }
  
  func didSelectCellAtIndexPath(indexPath:NSIndexPath){
    selectedBuild = builds?[indexPath.row]
    alertViewManager.showAlertView("TAKE CONTROL!!!!", message: "You have the power", cancelButtonTitle: "Cancel", cancelButtonAction: nil, otherButtonTitles:["STOP THE BUILD","Rebuild"], otherButtonActions:[ cancelAction,rebuildAction])
  }
  
  func cancelAction(){
    SVProgressHUD.showWithStatus("Ok lets try to cancel the build")
    if let selectedBuild = selectedBuild{
    cancelBuild(selectedBuild, successCallback: {
      SVProgressHUD.showSuccessWithStatus("Its gone!")
      self.getData()
      }) { (error) -> () in
        SVProgressHUD.showErrorWithStatus(error.localizedDescription)
      }
    }else{
      SVProgressHUD.showErrorWithStatus("no selected build")
    }
  }
  
  func rebuildAction(){
    SVProgressHUD.showWithStatus("Ok lets try to rebuild the ......build")
    if let selectedBuild = selectedBuild{
      rebuild(selectedBuild, successCallback: {
        SVProgressHUD.showSuccessWithStatus("Its building!")
        self.getData()
        }) { (error) -> () in
          SVProgressHUD.showErrorWithStatus(error.localizedDescription)
      }
    }else{
      SVProgressHUD.showErrorWithStatus("no selected build")
    }
  }
  
  func getProjectsNames()->[String]{
    var strArray = [String]()
    if let projects = projects{
    for projct in projects{
      strArray.append(projct.reponame!)
      }
    }
    return strArray
  }
}