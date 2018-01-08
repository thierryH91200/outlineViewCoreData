//
//  EntityAffectation+CoreDataProperties.swift
//  THOutlineViewCoreData
//
//  Created by thierryH24 on 07/01/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//
//

import Foundation
import CoreData


extension EntityAffectation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityAffectation> {
        return NSFetchRequest<EntityAffectation>(entityName: "EntityAffectation")
    }

    @NSManaged public var name: String?
    @NSManaged public var color: NSObject?
    @NSManaged public var category: NSSet?
//    @NSManaged public var total : Double
}

// MARK: Generated accessors for category
extension EntityAffectation {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: EntityCategory)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: EntityCategory)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}

extension EntityAffectation {
    
    @objc var  children : NSSet {
        return category!
    }
    
    @objc var count : Int {
        return category!.count
    }
    
    @objc var isLeaf : Int {
        return 0
    }
    
}

extension EntityAffectation {
    @objc var total : Double {
        // Create and cache the section total on demand.
        
        self.willAccessValue(forKey: "total")
        var _total = self.primitiveValue(forKey: "total") as! Double
        self.didAccessValue(forKey: "total")
        
        _total = 0.0
        let sousTotals = category?.allObjects as! [EntityCategory]
        for soustotal in sousTotals {
            _total += soustotal.objectif
        }
        self.setPrimitiveValue(_total, forKey: "total")
        return _total
    }
}

