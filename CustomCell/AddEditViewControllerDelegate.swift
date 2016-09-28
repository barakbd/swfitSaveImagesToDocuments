//
//  CustomCellDelegate.swift
//  CustomCell
//
//  Created by Barak Ben-David on 9/15/16.
//  Copyright © 2016 Barak Ben-David. All rights reserved.
//

import Foundation
import UIKit

protocol AddEditViewControllerDelegate: class{
//    func descriptionButtonPressed(controller: AddEditViewController, memory: Memory)
//    func AddEditViewControllerDelegate(controller: AddEditViewController, didFinishAddingMemory memoryName: String, memoryDesc: String)
    func AddEditViewControllerDelegate(controller: AddEditViewController, didFinishAddingMemory newMemoryDictionary: NSDictionary)
    func AddEditViewControllerDelegate(controller: AddEditViewController, didFinishEditingingMemory edited: Bool)
    
    // Delegate for description button
    func AddEditViewControllerDelegate(memoryCellToShow: MemoryCustomCell)


}