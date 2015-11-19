//
//  ViewController.swift
//  CircleCi
//
//  Created by Greg Pugh on 17/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var viewView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    textView.panGestureRecognizer.allowedTouchTypes = [UITouchType.Indirect.rawValue]
  }
  
  override func viewDidAppear(animated: Bool) {
    
    let path = "https://circleci.com/api/v1/recent-builds?circle-token=af5180393c26adc087340e9bc5fb2d96405ef289&limit=20&offset=5"

    getRecentBuildsAcrossAllProjects(path, successCallback: { (response) -> () in
      print(response)
      if let res = (response as? NSArray) {
        print("AsSynchronous\(res)")
        dispatch_async(dispatch_get_main_queue()){
            self.textView.text = res.description
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
        print("AsSynchronous\(jsonResult)")
        successCallback(jsonResult)
      }
      if let error = error {
        failureCallback(error)
      }

    }
    task.resume()

  }
 
  
}
