//
//  BuildCollectionViewCell.swift
//  CircleCi
//
//  Created by Greg Pugh on 20/11/2015.
//  Copyright © 2015 Marks and Spencer. All rights reserved.
//

import UIKit

class BuildCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var buildLabel: UILabel!
  @IBOutlet weak var BuildView: UIView!
  @IBOutlet weak var projectLabel: UILabel!
  @IBOutlet weak var branchLabel: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var userLabel: UILabel!
}
