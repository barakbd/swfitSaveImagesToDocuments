//
//  MemoryCellClass.swift
//  CustomCell
//
//  Created by Barak Ben-David on 9/15/16.
//  Copyright © 2016 Barak Ben-David. All rights reserved.
//

import Foundation
import UIKit

class MemoryCustomCell: UITableViewCell{
//    var delegate: CustomMemoryCellDelegate?
    
    var delegate: AddEditViewControllerDelegate?
    @IBOutlet weak var memoryImage: UIImageView!
    @IBOutlet weak var memoryNameLabel: UILabel!
    
    @IBAction func descriptionButtonPressed(sender: UIButton) {
        delegate?.AddEditViewControllerDelegate(self)
    }
}


