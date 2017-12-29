//
//  MainWindowControllerDragDrop.swift
//  outlineViewCoreData
//
//  Created by thierryH24 on 29/12/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Foundation
import Cocoa



extension MainWindowController: NSOutlineViewDataSource {

    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        debugPrint("Drag session ended")
        self.draggedNode = nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        draggedNode = draggedItems[0] as AnyObject?
        session.draggingPasteboard.setData(Data(), forType: NSPasteboard.PasteboardType(rawValue: "DragType"))
        debugPrint("Drag session begin")
    }

    func outlineView(_ outlineView: NSOutlineView, writeItems items: [Any], to pasteboard: NSPasteboard) -> Bool {
        pasteboard.declareTypes(dragType , owner: self)
        draggedNode = items[0]
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        let item1 = item as? NSTreeNode
        let item2 = item1?.representedObject as? NSManagedObject
        
        let draggedNode1 = draggedNode as? NSTreeNode
        let draggedTreeNode = draggedNode1?.representedObject as! NSManagedObject
        
        draggedTreeNode.setValue(item2, forKey: "parent")
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        
        let retVal = NSDragOperation()
        
        // drags to the root are always acceptable
        let item1 = item as? NSTreeNode
        if item1?.representedObject == nil {
            return .generic
        }
        // Verify that we are not dragging a parent to one of it's ancestors
        // causes a parent loop where a group of nodes point to each other
        // and disappear from the control
        
        let draggedNode1 = draggedNode as? NSTreeNode
        let dragged = draggedNode1?.representedObject as! NSManagedObject
        
        let newP = item1?.representedObject as! NSManagedObject
        if category(dragged, isSubCategoryOf: newP) {
            
            return retVal
        }
        return .generic
    }

    
    func category(_ cat: NSManagedObject, isSubCategoryOf possibleSub: NSManagedObject) -> Bool {
        // Depends on your interpretation of subCategory ....
        if cat == possibleSub {
            return true
        }
        var possSubParent = possibleSub.value(forKey: "parent") as? NSManagedObject
        if possSubParent == nil {
            return false
        }
        while possSubParent != nil {
            if possSubParent == cat {
                return true
            }
            // move up the tree
            possSubParent = possSubParent?.value(forKey: "parent") as? NSManagedObject
        }
        return false
    }
    
    

}
