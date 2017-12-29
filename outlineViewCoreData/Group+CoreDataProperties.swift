//
//  Group+CoreDataProperties.swift
//  outlineViewCoreData
//
//  Created by thierryH24 on 28/12/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//
//

import Foundation
import CoreData


extension Group {

    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged   @objc public var name: String?
    @NSManaged public var parent: Group?
    @NSManaged public var subGroups: NSSet?

}

// MARK: Generated accessors for subGroups
extension Group {

    @objc(addSubGroupsObject:)
    @NSManaged public func addToSubGroups(_ value: Group)

    @objc(removeSubGroupsObject:)
    @NSManaged public func removeFromSubGroups(_ value: Group)

    @objc(addSubGroups:)
    @NSManaged public func addToSubGroups(_ values: NSSet)

    @objc(removeSubGroups:)
    @NSManaged public func removeFromSubGroups(_ values: NSSet)

}
