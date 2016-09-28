//
//  imageDocumentManager.swift
//  CustomCell
//
//  Created by Barak Ben-David on 9/25/16.
//  Copyright © 2016 Barak Ben-David. All rights reserved.
//

import Foundation
import UIKit

class imageDocumentManager{
    
    // ======================================================== Path (String) methods - working ==============================================================================
    
    //Note: Apparently Path can change between app launches  - preferable to use URL methods, create bookmark to diretory and save bookmark in NSUserDefaults
    
    static func getDirectoryPath() -> String {
        print("imageDocumentManager - getDirectoryPath")
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        print("imageDocumentManager - getDirectoryPath - ", documentsDirectory)
        return documentsDirectory
    }
    
    
    static func saveImageToDocumentsByPathByName(memoryName: String, memoryImage: UIImage) -> Bool{
        
        print("imageDocumentManager - saveImageDocumentDirectory")
        //Remove white spaces from memory name
        let trimmedName = memoryName.stringByReplacingOccurrencesOfString(" ", withString: "")
        print("trimmed name is", trimmedName)
        let imagePath = (self.getDirectoryPath() as NSString).stringByAppendingPathComponent(trimmedName + ".jpg")
        print("imagePath path is", imagePath)
        let imageData = UIImageJPEGRepresentation(memoryImage, 0.5)
        
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(imagePath){
            print("file does not exist")
            //createFileAtPath - cannot over write file
            if fileManager.createFileAtPath(imagePath as String, contents: imageData, attributes: nil){
                print("File saved")
                return true
            }else{
                print("Error Saving")
                return false
            }
        }else{
            print("File exists")
            return false
        }
    }
    
    
    static func findImageFromDocumentsByPathByName(memoryName: String) -> UIImage{
        print("imageDocumentManager - findImageByMemoryName")
        //Remove white spaces from memory name
        let trimmedName = memoryName.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let imagePath = (self.getDirectoryPath() as NSString).stringByAppendingPathComponent(trimmedName + ".jpg")
        print("imagePath is - ", imagePath)
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(imagePath){
            if let foundImage = UIImage(contentsOfFile: imagePath){
                print("found image")
                return foundImage
            }
        }
        else{
            print("No Image found")
        }
        return UIImage(named: "MinionLuau")!
    }
    
    //removeItemAtPath()
    static func removeIamgeAtPath(memoryName: String) -> Bool{
        print("imageDocumentManager - removeIamgeAtPath")
        //Remove white spaces from memory name
        let trimmedName = memoryName.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let imagePath = (self.getDirectoryPath() as NSString).stringByAppendingPathComponent(trimmedName + ".jpg")
        
        print("imagePath is - ", imagePath)
        let fileManager = NSFileManager.defaultManager()
        do{
            try fileManager.removeItemAtPath(imagePath)
            print("image deleted")
            return true
            
        }catch{
            print("No Image found")
            return false
        }
    }

    
    // ======================================================== URL - not working perfectly ==============================================================================
    
    //Method to return Directory URL
    static func getDocumentsDirectoryByURL() -> NSURL{
        let documentsDirectoryURL = try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        return documentsDirectoryURL
    }
    
    
    //save new image - imageName does not exist
    static func saveImageToDocumentWithNSurlByName(memoryName: String, image: UIImage) -> Bool{
        print("imageDocumentManager - saveImageToDocumentWithNSurlByName")
        let trimmedName = memoryName.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let documentsDirectoryURL = getDocumentsDirectoryByURL()
        // create a name for your image
        let imageURL = documentsDirectoryURL.URLByAppendingPathComponent(trimmedName)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(imageURL.path!) {
            if UIImageJPEGRepresentation(image, 1.0)!.writeToFile(imageURL.path!, atomically: true) {
                print("file saved")
                return true
            } else {
                print("error saving file")
                return false
            }
        } else {
            print("file already exists")
            return false
        }
    }
    
    //find image - show different directory for some reason
    static func findImageFromURLByImageName(memoryName: String) -> UIImage{
        print("imageDocumentManager - findImageFromURLByImageName")
        //Remove white spaces from memory name
        let trimmedName = memoryName.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let documentsDirectoryURL = getDocumentsDirectoryByURL()
        
        let imageURL = documentsDirectoryURL.URLByAppendingPathComponent(trimmedName)
        print("imageURL is - ", imageURL)
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(imageURL.absoluteString){
            if let foundImage = UIImage(contentsOfFile: imageURL.absoluteString){
                print("found image")
                return foundImage
            }
        }
        else{
            print("No Image found")
        }
        return UIImage(named: "MinionLuau")!
    }
    
    
    //removeItemAtURL()
    static func removeIamgeAtUrl(memoryName: String) -> Bool{
        print("imageDocumentManager - removeIamgeAtUrl")
        //Remove white spaces from memory name
        let trimmedName = memoryName.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let documentsDirectoryURL = getDocumentsDirectoryByURL()
        
        let imageURL = documentsDirectoryURL.URLByAppendingPathComponent(trimmedName)
        print("imageURL is - ", imageURL)
        let fileManager = NSFileManager.defaultManager()
        do{
            try fileManager.removeItemAtURL(imageURL)
            print("image deleted")
            return true
            
        }catch{
            print("No Image found")
            return false
        }
    }
    
} //END class


