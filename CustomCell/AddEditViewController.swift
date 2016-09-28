//
//  AddEditViewController.swift
//  CustomCell
//
//  Created by Barak Ben-David on 9/15/16.
//  Copyright © 2016 Barak Ben-David. All rights reserved.
//

import Foundation
import UIKit

class AddEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{


    override func viewDidLoad() {
        print("AddEditViewController - view loaded")
        super.viewDidLoad()
        nameFieldRequired.hidden = true
        // Set this controller as the camera delegate
        imagePicker.delegate = self
        
        if let unwrappedMemoryToEdit = memoryToEdit{
            print(unwrappedMemoryToEdit)
            newMemoryName.text = unwrappedMemoryToEdit.name
            newMemoryDesc.text = unwrappedMemoryToEdit.desc
        }
        newMemoryName.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


    // ============ outlets =================

    @IBOutlet weak var newMemoryImage: UIImageView!
    @IBOutlet weak var newMemoryName: UITextField!
    @IBOutlet weak var newMemoryDesc: UITextField!
    
    @IBOutlet weak var nameFieldRequired: UILabel!
    var imagePicked = false
    
    var cancelDelegate: CancelDelegate?
    var addEditDelegate: AddEditViewControllerDelegate?
    //placeholder for Memory to edit - from description page
    var memoryToEdit: Memory?
    
    // ============ buttons =================

    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        print("AddEditViewController - cancelButtonPressed")
        dismissViewControllerAnimated(true, completion: nil)
//        cancelDelegate?.cancelButtonPressedFrom(self)
    }

    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        print("AddEditViewController - doneButtonPressed")
        //remove leading and trailing white spaces
        if newMemoryName.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""{
            nameFieldRequired.hidden = false
            print("Name Field is empty")
            newMemoryName.resignFirstResponder()
            return
        }
        if let unwrappedMemoryToEdit = memoryToEdit{
            unwrappedMemoryToEdit.name = newMemoryName.text
            unwrappedMemoryToEdit.desc = newMemoryDesc.description
            addEditDelegate?.AddEditViewControllerDelegate(self, didFinishEditingingMemory: true)
        }else{
            print("imagePicked - ", imagePicked)
            let newMemorryDictionary:NSMutableDictionary = [
                "name": newMemoryName.text!,
                "desc": newMemoryDesc.text!,
                "image": false
                ]
            if imagePicked{
                newMemorryDictionary["image"] = newMemoryImage.image
            }
            imagePicked = false
            addEditDelegate?.AddEditViewControllerDelegate(self, didFinishAddingMemory: newMemorryDictionary)
            
        }
    }
    
    
    // ================================== imagePicker ================================
    let imagePicker = UIImagePickerController()

    @IBAction func pickPhoto(sender: UITapGestureRecognizer) {
        print("UITapGestureRecognizer")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("User picked image")
        newMemoryImage.image = image
        imagePicked = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: nil)
        postAlert("Cancelled", message: "No photo chosen")
    }
    
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // ============ End imagePicker =================

    
    
} //END AddEditViewController