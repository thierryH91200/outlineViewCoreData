//
//  EntityCategory+CoreDataProperties.swift
//  outlineViewCoreData
//
//  Created by thierryH24 on 06/01/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//
//

import Foundation
import CoreData


extension EntityCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityCategory> {
        return NSFetchRequest<EntityCategory>(entityName: "EntityCategory")
    }

    @NSManaged public var name: String?
    @NSManaged public var objectif: Double
    @NSManaged public var affectation: EntityAffectation?

}

extension EntityCategory {
    
    @objc var  children : NSSet {
        return []
    }
    
    @objc var count : Int {
        return 0
    }
    
    @objc var isLeaf : Int {
        return 1
    }
    
}
