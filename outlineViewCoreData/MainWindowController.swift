//
//  MainWindowController.swift
//  outlineViewCoreData
//
//  Created by thierryH24 on 18/12/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    @IBOutlet var treeController: NSTreeController!
    @IBOutlet weak var myOutlineView: NSOutlineView!
    
    var dragType = [NSPasteboard.PasteboardType]()
    var draggedNode:Any? = nil
    
    @objc  var managedObjectContext: NSManagedObjectContext = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Just for the fun
        let notification = NSUserNotification()
        notification.title = "File Uploaded"
        notification.subtitle = "example.txt"
        notification.informativeText = "/Users/John/Documents/example.txt"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.contentImage = NSImage(named: NSImage.Name("icon_Upload-Information-icon_24x24"))
        NSUserNotificationCenter.default.deliver(notification)
        
        dragType = [NSPasteboard.PasteboardType(rawValue: "DragType")]
        myOutlineView.registerForDraggedTypes(dragType)
    }
        
}
