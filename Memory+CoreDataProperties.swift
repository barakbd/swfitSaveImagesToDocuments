//
//  Memory+CoreDataProperties.swift
//  CustomCell
//
//  Created by Barak Ben-David on 9/15/16.
//  Copyright © 2016 Barak Ben-David. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Memory {

    @NSManaged var name: String?
    @NSManaged var desc: String?

}
