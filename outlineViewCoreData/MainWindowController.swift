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
    
    @objc var managedObjectContext: NSManagedObjectContext = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @objc var dataSort = [NSSortDescriptor(key: "name", ascending: false)]
    @objc dynamic var customSortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))];

    
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
        
        let descriptorName = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        anOutlineView.tableColumns[0].sortDescriptorPrototype = descriptorName
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.anOutlineView.expandItem(nil, expandChildren: true)
        })
        
        dragType = [NSPasteboard.PasteboardType(rawValue: "DragType")]
        anOutlineView.registerForDraggedTypes(dragType)
        
        anTreeController.sortDescriptors = customSortDescriptors
    }
    
    func isHeader(item: Any) -> Bool {
        
        let draggedNode1 = item as? NSTreeNode
        var result = false
        
        if item is NSTreeNode
        {
            result =  draggedNode1?.representedObject is EntityAffectation
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
    
    @IBAction func changeCouleur(_ sender : NSColorWell)
    {
        let row = anOutlineView.row(for: sender as NSView)
        if row == -1 { return }
        
        let color = sender.color
        
        let item = anOutlineView.item(atRow: row) as? NSTreeNode
        let item1 = item?.representedObject as? NSManagedObject
        let result = item1 is EntityAffectation
        if result == true {
            let item2 = item1 as! EntityAffectation
            
            item2.color = color
            
            let select1 : IndexSet = [row]
            anOutlineView.selectRowIndexes(select1, byExtendingSelection: false)
        }
    }
    @IBAction func add(_ sender: Any) {
        let index = anOutlineView.selectedRowIndexes
        print(index)
    }
    
    @IBAction func addChild(_ sender: Any) {
        
        let index = anOutlineView.selectedRowIndexes
        print(index)

    }
    
    @IBAction func remove(_ sender: Any) {
        
        let selected = anOutlineView.selectedRowIndexes.map { Int($0) }
        let item = anOutlineView.item(atRow: selected[0])
        print(item)
        
        let item1 = item as? NSTreeNode
        let item2 = item1?.representedObject as? NSManagedObject
        let result = item2 is EntityAffectation
        print(result)
        if result == true {
            managedObjectContext.delete(item2!)
        } else {
            let entity = item2 as! EntityCategory
            let aff = entity.affectation
            aff?.removeFromCategory(entity)
            managedObjectContext.delete(item2!)
        }
        anTreeController.rearrangeObjects()

        
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        do {
            try managedObjectContext.save()
        } catch { }
        anTreeController.rearrangeObjects()

    }
}

extension MainWindowController: NSTextFieldDelegate {
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        
        anTreeController.rearrangeObjects()
    }
}

class KSHeaderCellView2 : NSTableCellView {
    
    @IBOutlet weak var colorWell:NSColorWell!
    @IBOutlet weak var total:NSTextField!
    
//    var fillColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    
    //    override func draw(_ dirtyRect: NSRect) {
    //        super.draw(dirtyRect)
    //
    //        let bPath = NSBezierPath(rect: dirtyRect)
    //
    //        fillColor.set()
    //        bPath.fill()
    //    }
}


class KSTableCellView2 : NSTableCellView {
    
    @IBOutlet weak var objectif:NSTextField!
}

