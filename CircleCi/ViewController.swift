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

  @IBOutlet weak var reloadLabel: UILabel!
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var buildViewModel:BuildViewModel?
  var branchBarButton: UIBarButtonItem!
  var projectBarButton: UIBarButtonItem!
  var speakerBarButton: UIBarButtonItem!
  
  var refreshWaitTime:Int?
  var currentRefreshTime = 0
  var timer:Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let titleView = UIImageView(image: UIImage(named: "titleImage"))
    self.navigationItem.titleView = titleView

    buildViewModel = BuildViewModel()
    buildViewModel?.delgate = self
    branchBarButton = UIBarButtonItem(title: "Branch", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.branchAction))
    projectBarButton = UIBarButtonItem(title: "Project", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.projectAction))
   self.navigationItem.rightBarButtonItems  = [branchBarButton, projectBarButton]
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    buildViewModel?.getData()
    refreshWaitTime = Int(getRefreshRate())
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    timer?.invalidate()
    currentRefreshTime = 0
  }
  
  func update(){
    currentRefreshTime += 1
    reloadLabel.text = "Reloading in \(refreshWaitTime! - currentRefreshTime)"
    
    if currentRefreshTime == refreshWaitTime{
      currentRefreshTime = 0
      buildViewModel?.getData()
    }
  }
  
  @IBAction func settingsAction(_ sender: AnyObject) {
    performSegue(withIdentifier: "seg_main_to_settings", sender: nil)
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
  
  @IBAction func refreshAction(_ sender: AnyObject) {
    currentRefreshTime = 0
    buildViewModel?.getData()
  }
  
  func speakerAction(){
    
  }
}

extension ViewController:BuildViewModelProtocol{
  func reloadCollectionView() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true);
    collectionView.reloadData()
  }
  
  func reloadButtons(_ projectName: String, branchName: String) {
    self.navigationItem.rightBarButtonItem = nil
    branchBarButton = UIBarButtonItem(title: branchName, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.branchAction))
    projectBarButton = UIBarButtonItem(title:  projectName, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.projectAction))
    self.navigationItem.rightBarButtonItems  = [branchBarButton, projectBarButton]
  }
  
  func navigateToSettings() {
    performSegue(withIdentifier: "seg_main_to_settings", sender: nil)
  }
}

extension ViewController:UICollectionViewDataSource{
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return buildViewModel!.numberOfSectionsInCollectionView()
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuildCollectionViewCell", for: indexPath) as! BuildCollectionViewCell
    
    if let buildModel = buildViewModel?.builds?[indexPath.row]{
      if let buildNum = buildModel.build_num{
        print("buildStatus" + buildModel.status! + " number :" + String(describing: buildNum))
        cell.buildLabel.text = "#\(String(describing: buildNum))"
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
      cell.contentView.layer.borderColor = buildModel.statusColour().cgColor
      cell.contentView.layer.masksToBounds = true
      cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
      cell.layer.shadowRadius = 2.0
      cell.layer.shadowOpacity = 1.0
      cell.layer.masksToBounds = false
      
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return buildViewModel!.numberOfCellsInCollectionView()
  }
  
  func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if ((context.nextFocusedView) != nil){
      coordinator.addCoordinatedAnimations({ () -> Void in
        context.nextFocusedView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    if ((context.previouslyFocusedView) != nil){
      coordinator.addCoordinatedAnimations({ () -> Void in
        context.previouslyFocusedView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
  }
}

extension ViewController:UICollectionViewDelegate{
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    buildViewModel?.didSelectCellAtIndexPath(indexPath)
  }
}

