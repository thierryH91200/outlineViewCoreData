//
//  MainWindowController.swift
//  outlineViewCoreData
//
//  Created by thierryH24 on 18/12/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSOutlineViewDelegate {
    
    @IBOutlet weak var anOutlineView: NSOutlineView!
    @IBOutlet var anTreeController: NSTreeController!
    
    var dragType = [NSPasteboard.PasteboardType]()
    var draggedNode:Any? = nil
    
    @objc  var managedObjectContext: NSManagedObjectContext = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     @objc let dataSort = NSSortDescriptor(key: "name", ascending: false)
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Just for the fun
        //        let notification = NSUserNotification()
        //        notification.title = "File Uploaded"
        //        notification.subtitle = "example.txt"
        //        notification.informativeText = "/Users/thierryH24/Documents/example.txt"
        //        notification.soundName = NSUserNotificationDefaultSoundName
        //        notification.contentImage = NSImage(named: NSImage.Name("icon_Upload-Information-icon_24x24"))
        //        NSUserNotificationCenter.default.deliver(notification)
        
        anOutlineView.delegate = self
        
        _ = Affectation.sharedInstance.getAllEntity()
        
        anOutlineView.allowsEmptySelection = false
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.anOutlineView.expandItem(nil, expandChildren: true)
        })
        
        dragType = [NSPasteboard.PasteboardType(rawValue: "DragType")]
        anOutlineView.registerForDraggedTypes(dragType)
    }
    
    func isHeader(item: Any) -> Bool {
        
        let draggedNode1 = item as? NSTreeNode
        var result = false
        
        if item is NSTreeNode
        {
            result =  (draggedNode1?.representedObject is EntityAffectation)
        } else
        {
            result =  draggedNode1?.representedObject  is EntityCategory
        }
        return result
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if isHeader(item: item) {
            return outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "headerCell"), owner: self)
        } else {
            return outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "dataCell"), owner: self)
        }
    }
    
    // ok
    // indicates whether a given row should be drawn in the “group row” style.
    public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool
    {
        return isHeader(item: item)
    }
    
    @IBAction func ExpandAll(_ sender: Any) {
        anOutlineView.allowsEmptySelection = false
        anOutlineView.expandItem(nil, expandChildren: true)
        anOutlineView.reloadData()
    }
}


class KSTableCellView2 : NSTableCellView {
    
    @IBOutlet weak var objectif:NSTextField!
}

