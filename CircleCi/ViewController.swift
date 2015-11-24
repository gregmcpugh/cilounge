//
//  ViewController.swift
//  CircleCi
//
//  Created by Greg Pugh on 17/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController {

  var buildViewModel:BuildViewModel?
  var branchBarButton: UIBarButtonItem!
  var projectBarButton: UIBarButtonItem!
  
  let refreshWaitTime = 30
  var currentRefreshTime = 0
  var timer:NSTimer?
  
  @IBOutlet weak var refreshButton: UIButton!
  
  @IBOutlet weak var collectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "CIRCLE"
    buildViewModel = BuildViewModel()
    buildViewModel?.delgate = self
    branchBarButton = UIBarButtonItem(title: "Branch", style: UIBarButtonItemStyle.Plain, target: self, action: "branchAction")
    projectBarButton = UIBarButtonItem(title: "Project", style: UIBarButtonItemStyle.Plain, target: self, action: "projectAction")
    self.navigationItem.rightBarButtonItems  = [branchBarButton, projectBarButton]
  }
  
  func update(){
    currentRefreshTime++
    
    refreshButton.setTitle( "Reloading in \(refreshWaitTime - currentRefreshTime)", forState: UIControlState.Normal)
    
    if currentRefreshTime == refreshWaitTime{
      currentRefreshTime = 0
      buildViewModel?.getData()
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    buildViewModel?.getData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func branchAction() {
    buildViewModel?.branchAction()
  }
  
  func projectAction() {
    buildViewModel?.projectAction()
  }
  
  @IBAction func refreshAction(sender: AnyObject) {
    currentRefreshTime = 0
    buildViewModel?.getData()
  }
}

extension ViewController:BuildViewModelProtocol{
  func reloadCollectionView() {
    timer?.invalidate()
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true);
    collectionView.reloadData()
  }
  
  func reloadButtons(projectName: String, branchName: String) {
    self.navigationItem.rightBarButtonItem = nil
    branchBarButton = UIBarButtonItem(title: branchName, style: UIBarButtonItemStyle.Plain, target: self, action: "branchAction")
    projectBarButton = UIBarButtonItem(title:  projectName, style: UIBarButtonItemStyle.Plain, target: self, action: "projectAction")
    self.navigationItem.rightBarButtonItems  = [branchBarButton, projectBarButton]
  }
}

extension ViewController:UICollectionViewDataSource{
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return buildViewModel!.numberOfSectionsInCollectionView()
  }
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BuildCollectionViewCell", forIndexPath: indexPath) as! BuildCollectionViewCell
    
    if let buildModel = buildViewModel?.builds?[indexPath.row]{
      if let buildNum = buildModel.build_num{
        print("buildStatus" + buildModel.status! + " number :" + String(buildNum))
        cell.buildLabel.text = "#\(String(buildNum))"
      }
      cell.branchLabel.text = buildModel.branch ?? ""
      cell.projectLabel.text = buildModel.reponame ?? ""
      cell.userLabel.text = buildModel.author_name ?? ""
      cell.descriptionTextView.text = buildModel.subject ?? ""
      cell.BuildView.backgroundColor = buildModel.statusColour()
      cell.statusLabel.text = buildModel.status ?? ""
      cell.timeLabel.text = buildModel.getTimeTaken()
      cell.contentView.layer.cornerRadius = 6.0
      cell.contentView.layer.borderWidth = 1.0
      cell.contentView.layer.masksToBounds = true
      cell.layer.shadowOffset = CGSizeMake(0, 2.0)
      cell.layer.shadowRadius = 2.0
      cell.layer.shadowOpacity = 1.0
      cell.layer.masksToBounds = false
      
    }
    return cell
  }
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return buildViewModel!.numberOfCellsInCollectionView()
  }
  
  func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    if ((context.nextFocusedView) != nil){
      coordinator.addCoordinatedAnimations({ () -> Void in
        context.nextFocusedView?.transform = CGAffineTransformMakeScale(1.1, 1.1)
        }, completion: nil)
    }
    if ((context.previouslyFocusedView) != nil){
      coordinator.addCoordinatedAnimations({ () -> Void in
        context.previouslyFocusedView?.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }, completion: nil)
    }
  }
  
  
}

extension ViewController:UICollectionViewDelegate{
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    buildViewModel?.didSelectCellAtIndexPath(indexPath)
  }
}

