//
//  ViewController.swift
//  CustomCell
//
//  Created by Barak Ben-David on 9/14/16.
//  Copyright © 2016 Barak Ben-David. All rights reserved.
//

import UIKit
import CoreData
let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

class MemoriesTableViewController: UITableViewController, CancelDelegate, AddEditViewControllerDelegate {
    
    
    var memoriesArray = [Memory]()
    
    // ============ Buttons =================
    @IBAction func addButton(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("ChangeMemories", sender: sender)
    }
    
    
    override func viewDidLoad() {
        print("MemoriesTableViewController - view loaded")
        self.refreshControl?.addTarget(self, action: #selector(self.getAllMemoriesFromCoreData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getAllMemoriesFromCoreData(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ============ Core Data Methods =================
    
    // Gett all data from Core Data
    func getAllMemoriesFromCoreData(refreshControl: UIRefreshControl?){
        print("getAllMemoriesFromCoreData")
        let memoriesRequest = NSFetchRequest(entityName: "Memory")
        var error: NSError? = nil
        print("memories count is", managedObjectContext.countForFetchRequest(memoriesRequest, error: &error))
        
        do {
            // get the results by executing the fetch request we made earlier
            let memories = try managedObjectContext.executeFetchRequest(memoriesRequest)
            // downcast the results as an array of Mission objects
            memoriesArray = memories as! [Memory]
            // print the details of each memory
            for memory in memoriesArray {
                print("\(memory.name)+\(memory.desc)")
            }
        } catch {
            // print the error if it is caught (Swift automatically saves the error in "error")
            print("\(error)")
        }
        tableView.reloadData()
        
        if let unWrappedRefreshControl = refreshControl{
            unWrappedRefreshControl.endRefreshing()
        }
        
    } // END getAllMemoriesFromCoreData
    
    
    
    //Save changes
    func saveManagedObjectChanges(){
        print("saveManagedObjectChanges")
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success saving managedObjectContext")
            } catch {
                print("\(error)")
            }
        }
    }
    
    
    
    
    // ============ TableView Methods =================
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoriesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("tableView - cellForRowAtIndexPath")
        let cell = tableView.dequeueReusableCellWithIdentifier("MemoryCustomCell") as! MemoryCustomCell
        cell.memoryNameLabel.text = memoriesArray[indexPath.row].name
        //Send self as delegate for segue to show memory page
        cell.delegate = self
        //If image is saved in project as asset, use:
        //cell.memoryImage.image = UIImage(named: "\(memoriesArray[indexPath.row].name)")
//        cell.memoryImage.image = imageDocumentManager.findImageFromURLByImageName(memoriesArray[indexPath.row].name!)
        cell.memoryImage.image = imageDocumentManager.findImageFromDocumentsByPathByName(memoriesArray[indexPath.row].name!)
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            // Remove image from documents
            imageDocumentManager.removeIamgeAtPath(memoriesArray[indexPath.row].name!)

            //delete from context
            managedObjectContext.deleteObject(memoriesArray[indexPath.row])
            let memoriesRequest = NSFetchRequest(entityName: "Memory")
            var error: NSError? = nil
            
            
            print(managedObjectContext.countForFetchRequest(memoriesRequest, error: &error))
            // remove the array at indexPath
            memoriesArray.removeAtIndex(indexPath.row)
            
            saveManagedObjectChanges()
            
            // reload the table view - no need to reload whole table
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
        default:
            return
        }
    }
    // ========================== Delegate Methods =========================
    
    func cancelButtonPressedFrom(controller: UIViewController) {
        print("MemoriesTableViewController - cancelButtonPressedFrom", controller)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func AddEditViewControllerDelegate(controller: AddEditViewController, didFinishAddingMemory newMemoryDictionary: NSDictionary) {
        print("MemoriesTableViewController - didFinishAddingMemory", newMemoryDictionary)
        dismissViewControllerAnimated(true, completion: nil)
        let newMemory = NSEntityDescription.insertNewObjectForEntityForName("Memory", inManagedObjectContext: managedObjectContext) as! Memory
        
        if let unwrappedMemoryDesc = newMemoryDictionary["desc"] as? String{
            print("desc sent")
            newMemory.desc = unwrappedMemoryDesc
        }
        
        if let unwrappedMemoryName = newMemoryDictionary["name"] as? String{
            print("name sent")
            newMemory.name = unwrappedMemoryName
            
            //This method works - but apparently it is better to use url methods  - the application directory can change between app launches, so the only way to persistintly reference it is by setting a url bokmark
                        if let unwrappedMemoryImage = newMemoryDictionary["image"] as? UIImage{
                            print("new Image selected by user - trying to save to docuemnts")
                            //Save image to user Documents folder
                            if imageDocumentManager.saveImageToDocumentsByPathByName(unwrappedMemoryName, memoryImage: unwrappedMemoryImage){
                                print("AddEditViewControllerDelegate - image saved - retruning")
                                saveManagedObjectChanges()
                                getAllMemoriesFromCoreData(nil)
                                return
                            }
                        }
        }
        //If no image was returned
        saveManagedObjectChanges()
        getAllMemoriesFromCoreData(nil)
    }
    
    func AddEditViewControllerDelegate(controller: AddEditViewController, didFinishEditingingMemory edited: Bool) {
        dismissViewControllerAnimated(true, completion: nil)
        saveManagedObjectChanges()
        getAllMemoriesFromCoreData(nil)
        
    }
    func AddEditViewControllerDelegate(memoryCellToShow: MemoryCustomCell) {
        performSegueWithIdentifier("showMemory", sender: memoriesArray[tableView.indexPathForCell(memoryCellToShow)!.row])
    }
    
    
    
    // ==================================segue  =================================
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChangeMemories"{
            print("segue ChangeMemories")
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddEditViewController
            controller.cancelDelegate = self
            controller.addEditDelegate = self
        }else if segue.identifier == "showMemory"{
            let controller = segue.destinationViewController as! ShowViewController
            controller.memory = sender! as? Memory
            controller.delegate = self
        }
    }
    
    
} // END MemoriesTableViewController