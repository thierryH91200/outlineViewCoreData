//
//  MainWindowController.swift
//  outlineViewCoreData
//
//  Created by thierryH24 on 18/12/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController , NSOutlineViewDataSource {
    
    @IBOutlet var treeController: NSTreeController!
    @IBOutlet var arrayController: NSArrayController!
    @IBOutlet weak var myOutlineView: NSOutlineView!
    
    // sDWF6OfQ_K9PTky4lAratXxj6im4_szvQOpNBRCGsMALoVbwwd
    var dragType = [NSPasteboard.PasteboardType]()
    var draggedNode:Any? = nil
    
    var data = [Group]()
    
    @objc  var managedObjectContext: NSManagedObjectContext = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let notification = NSUserNotification()
        notification.title = "File Uploaded"
        notification.subtitle = "example.txt"
        notification.informativeText = "/Users/John/Documents/example.txt"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.contentImage = NSImage(named: NSImage.Name("icon_Upload-Information-icon_24x24"))
        NSUserNotificationCenter.default.deliver(notification)
        
        data = getAllEntity()
        
        dragType = [NSPasteboard.PasteboardType(rawValue: "factorialDragType")]
        myOutlineView.registerForDraggedTypes(dragType)
    }
    
    @IBAction func foo(_ sender: Any) {
        let theArrObjFromArrCtrl = arrayController.arrangedObjects as? [Group]
        for theGrp in theArrObjFromArrCtrl! {
            print("\(String(describing: theGrp.name))")
        }
    }
    
    func getAllEntity() -> [Group] {
        
        do {
            let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
            //            let predicate = NSPredicate(format: "compte == %@", compteCourant!)
            //            fetchRequest.predicate = predicate
            
            data = try managedObjectContext.fetch(fetchRequest)
        }catch {
            print("Error fetching data from CoreData")
        }
        for d in data {
            print(d.name!)
            print(d.parent ?? "nil")
            print(d.subGroups ?? "nil")
            print()



        }
        return data
    }
    
    
    func addData() {
        let root: [String : Any] = [ "name": "Max Mustermann", "isLeaf": false ]
        let dict = NSMutableDictionary(dictionary: root)
        dict.setObject([Group()], forKey: "children" as NSCopying)
        
        treeController.addObject(dict)
    }
    
    
    @objc  func isHeader(item: AnyObject) -> Bool {
        if let item = item as? NSTreeNode {
            return !(item.representedObject is Group)
        } else {
            return !(item is Group)
        }
    }
    
    // This method gets called by the framework but
    // the values from bindings are used instead
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return 1
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return true
    }
    
    // Returns the child item at the specified index of a given item
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return 1
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
    
func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
    
    var retVal:NSDragOperation = NSDragOperation()
    
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
    retVal = .generic
    return retVal
}
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        debugPrint("Drag session ended")
        self.draggedNode = nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        draggedNode = draggedItems[0] as AnyObject?
        session.draggingPasteboard.setData(Data(), forType: NSPasteboard.PasteboardType(rawValue: "factorialDragType"))
        debugPrint("Drag session begin")
        
    }


}
