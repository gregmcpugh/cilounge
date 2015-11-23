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
  
  @IBOutlet weak var collectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "CIRCLE"
    buildViewModel = BuildViewModel()
    buildViewModel?.delgate = self
    
  }
  
  override func viewDidAppear(animated: Bool) {
    buildViewModel?.getData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func branchAction(sender: AnyObject) {
    buildViewModel?.branchAction()
  }
  
  @IBAction func projectAction(sender: AnyObject) {
    buildViewModel?.projectAction()
  }
  
  @IBAction func refreshAction(sender: AnyObject) {
    buildViewModel?.getData()
  }
}
extension ViewController:BuildViewModelProtocol{
  func reloadCollectionView() {
    collectionView.reloadData()
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

//      cell.layer.cornerRadius = 6
      
      cell.contentView.layer.cornerRadius = 6.0
      cell.contentView.layer.borderWidth = 1.0
//      cell.contentView.layer.borderColor = CGC .clearColor()
      cell.contentView.layer.masksToBounds = true
      
//      cell.layer.shadowColor = [UIColor CGColor]
      cell.layer.shadowOffset = CGSizeMake(0, 2.0)
      cell.layer.shadowRadius = 2.0
      cell.layer.shadowOpacity = 1.0
      cell.layer.masksToBounds = false
//      cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
      
      
      
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

