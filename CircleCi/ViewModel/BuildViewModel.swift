//
//  BuildViewModel.swift
//  CircleCi
//
//  Created by Adrian Wu on 20/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

protocol BuildViewModelProtocol:class{
  func reloadCollectionView()
  func reloadButtons(_ projectName:String, branchName:String)
  func navigateToSettings()
}

class BuildViewModel{
  var projects:[Project]?
  var selectedProject:Project?
  var selectedBranchName:String?
  var selectedBuild:Build?
  var runningBuilds:[Build]?
  var speakerOn:Bool = false
  var builds:Array<Build>?
  
  lazy var alertViewManager: UIAlertControllerManager = {
    UIAlertControllerManager()
  }()
  
  weak var delgate:BuildViewModelProtocol?
  
  func getData(){
    getAllBuilds()
  }
  
  func getAllBuilds() {
    DispatchQueue.main.async{
      SwiftSpinner.show("ITS LOADING!!! GET OVER IT")
    }
    getBuildForProjects(selectedProject?.username, projectName: selectedProject?.reponame, branch: selectedBranchName, successCallback: { (response) -> () in
      DispatchQueue.main.async{
          SwiftSpinner.showWithDuration(0.4, title: "OK ITS Finished", animated: false)
      }
      if let res = (response as? NSArray) {
        self.builds = res as? Array<Build>
        DispatchQueue.main.async{
          self.delgate?.reloadCollectionView()
        }
        getProjects({response -> () in
          self.projects = response as! [Project]
          }) { error -> () in
        }
      }
      }) { (error) -> () in
        DispatchQueue.main.async{
        SwiftSpinner.hide()
        }
        if error.code == 401 {
          self.alertViewManager.showAlertView("Invalied API Key", message: "The API key provided is either missing or incorrect, please try again.", cancelButtonTitle: "Ok", cancelButtonAction: self.delgate?.navigateToSettings, otherButtonTitles: nil, otherButtonActions: nil)
        } else {
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

  func checkPreviousBuildStatus(_ newBuilds:[Build]){
    
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
  
  func didSelectCellAtIndexPath(_ indexPath:IndexPath){
    selectedBuild = builds?[indexPath.row]
    alertViewManager.showAlertView("TAKE CONTROL!!!!", message: "You have the power", cancelButtonTitle: "Cancel", cancelButtonAction: nil, otherButtonTitles:["STOP THE BUILD","Rebuild"], otherButtonActions:[ cancelAction,rebuildAction])
  }
  
  func cancelAction(){
    SwiftSpinner.show("Ok lets try to cancel the build")
    if let selectedBuild = selectedBuild{
    cancelBuild(selectedBuild, successCallback: {
      SwiftSpinner.show("Its gone!", animated: false)
      self.getData()
      }) { (error) -> () in
        
        SwiftSpinner.showWithDuration(2.0, title: error.localizedDescription, animated: false)
        
      }
    }else{
      
        SwiftSpinner.showWithDuration(2.0, title: "no selected build", animated: false)
      
    }
    SwiftSpinner.hide()
  }
  
  func rebuildAction(){
    SwiftSpinner.show("Ok lets try to rebuild the ......build")
    if let selectedBuild = selectedBuild{
      rebuild(selectedBuild, successCallback: {
        SwiftSpinner.showWithDuration(2.0, title: "Its building", animated: false)
        self.getData()
        }) { (error) -> () in
        
            SwiftSpinner.showWithDuration(2.0, title: error.localizedDescription, animated: false)
          
        }
    }else{
      
        SwiftSpinner.showWithDuration(2.0, title: "no selected build", animated: false)
      
      
    }
    SwiftSpinner.hide()
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
