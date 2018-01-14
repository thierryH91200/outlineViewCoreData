/**
 @file      EntityCategory+CoreDataProperties.swift
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
