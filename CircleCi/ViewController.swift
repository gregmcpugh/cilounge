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

  var builds:Array<Build>?
  @IBOutlet weak var collectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "CIRCLE"
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(animated: Bool) {
    
    let path = "https://circleci.com/api/v1/recent-builds?circle-token=af5180393c26adc087340e9bc5fb2d96405ef289&limit=50&offset=5"

    getRecentBuildsAcrossAllProjects(path, successCallback: { (response) -> () in
      print(response)
      if let res = (response as? NSArray) {
        print("AsSynchronous\(res)")
        dispatch_async(dispatch_get_main_queue()){
          self.collectionView.reloadData()
          }
      }
      }) { (error) -> () in
        print(error.localizedDescription)
    }

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func getRecentBuildsAcrossAllProjects(path:String, successCallback:AnyObject ->() ,  failureCallback:NSError!->() ) {

    let url: NSURL = NSURL(string: path)!
    let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request1.setValue("application/json", forHTTPHeaderField: "Accept")

    let queue:NSOperationQueue = NSOperationQueue()
    
    let task  = NSURLSession.sharedSession().dataTaskWithRequest(request1){ data, response, error in
      if let jsonResult: NSArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray {
        
        self.builds = Mapper<Build>().mapArray(jsonResult)!
        print("AsSynchronous\(self.builds)")
        successCallback(self.builds!)
      }
      if let error = error {
        failureCallback(error)
      }

    }
    task.resume()

  }
}

extension ViewController:UICollectionViewDataSource{
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BuildCollectionViewCell", forIndexPath: indexPath) as! BuildCollectionViewCell
    
    if let buildModel = builds?[indexPath.row]{
      if let buildNum = buildModel.build_num{
        print("buildStatus" + buildModel.status! + " number :" + String(buildNum))

        cell.buildLabel.text = "#\(String(buildNum))"
      }
      cell.branchLabel.text = buildModel.branch ?? ""
      cell.projectLabel.text = buildModel.reponame ?? ""
      cell.userLabel.text = buildModel.author_name ?? ""
      cell.descriptionTextView.text = buildModel.subject ?? ""
      cell.BuildView.backgroundColor = buildModel.statusColour()
      
    }
    return cell
  }
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.builds?.count ?? 0
  }
  func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
    print("did highlight")
  }
  func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    print("should highlight")
    
    return true
  }
  
  func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    print("did update focus")
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
    print("touches are working")
  }
}

