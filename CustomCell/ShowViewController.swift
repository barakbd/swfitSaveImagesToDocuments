//
//  ShowViewController.swift
//  CustomCell
//
//  Created by Barak Ben-David on 9/25/16.
//  Copyright © 2016 Barak Ben-David. All rights reserved.
//

import Foundation
import UIKit

class ShowViewController: UIViewController{
    
    var memory: Memory?
    var delegate: AddEditViewControllerDelegate?
    
    @IBOutlet weak var meoryImage: UIImageView!
    @IBOutlet weak var memoryName: UILabel!
    @IBOutlet weak var memoryDescription: UILabel!
    
    override func viewDidLoad() {
        print("ShowViewController - view loaded")
        super.viewDidLoad()
        // Set this controller as the camera delegate
        
        if let unwrappedMemory = memory{
            print(memory)
            memoryName.text = unwrappedMemory.name
            memoryDescription.text = unwrappedMemory.desc
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddEditViewController
            if let unwrappedMemory = memory{
                controller.memoryToEdit = unwrappedMemory
                controller.addEditDelegate = delegate!
            }
        }
        
    }
}