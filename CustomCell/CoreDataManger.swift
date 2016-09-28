//
//  CoreDataManger.swift
//  CustomCell-saveImageToDocuments
//
//  Created by Barak Ben-David on 9/27/16.
//  Copyright © 2016 Barak Ben-David. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager{
    
    
    // Gett all data from Core Data
    static func getAllFromCoreData(dataArray: NSArray, entity: NSObject, objectKey: String?, filter: String?, refreshControl: UIRefreshControl?) -> NSArray{
        var tempDataArray: NSArray = [entity]
        print("getAllMemoriesFromCoreData")
        let dataRequest = NSFetchRequest(entityName: entity as! String)
        
        //filter while fetching
        if let objectKey = objectKey{
            if let filter = filter{
                let predicate = NSPredicate(format: objectKey, " = %@", filter)
                dataRequest.predicate = predicate
            }
        }
        
        //count
        var error: NSError? = nil
        print("memories count is", managedObjectContext.countForFetchRequest(dataRequest, error: &error))
        
        do {
            // get the results by executing the fetch request we made earlier
            let data = try managedObjectContext.executeFetchRequest(dataRequest)
            // downcast the results as an array of Mission objects
            tempDataArray = data as NSArray
            // print the details of each memory
        } catch {
            // print the error if it is caught (Swift automatically saves the error in "error")
            print("\(error)")
        }
        
        if let unWrappedRefreshControl = refreshControl{
            unWrappedRefreshControl.endRefreshing()
        }
        return tempDataArray
    } // END getAllMemoriesFromCoreData
    
    
    
    //Save changes
    static func saveManagedObjectChanges(){
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

}