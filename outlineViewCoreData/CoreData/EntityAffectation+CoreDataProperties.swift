/**
 @file      EntityAffectation+CoreDataProperties.swift
 @author    thierryH91200
 @date      07/01/2018

 Copyright 2018 thierryH91200

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

*/

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

