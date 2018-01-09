//
//  MainWindowController.swift
//  outlineViewCoreData
//
//  Created by thierryH24 on 18/12/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSOutlineViewDelegate  {
    
    @IBOutlet weak var anOutlineView: NSOutlineView!
    @IBOutlet var anTreeController: NSTreeController!
    
    var dragType = [NSPasteboard.PasteboardType]()
    var draggedNode:Any? = nil
    
    @objc var managedObjectContext: NSManagedObjectContext = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var moc: NSManagedObjectContext = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    @objc dynamic var customSortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))];

    var addModalWindowController:AddModalWindowController!
    var addChildModalWindowController:AddChildModalWindowController!

    override func windowDidLoad() {
        super.windowDidLoad()
                
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
        guard  row != -1 else { return }
        
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
        
        let selected = anOutlineView.selectedRowIndexes.map { Int($0) }
        print(selected)

        self.addModalWindowController = AddModalWindowController(windowNibName: NSNib.Name(rawValue: "AddModalWindowController"))
        self.window?.beginSheet(addModalWindowController.window!, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in

            print("Sheet closed")
            switch returnCode {
            case .OK:
                let name = self.addModalWindowController.name.stringValue
                print(name)
                let color = self.addModalWindowController.colorWell.color
                print(color)
                
                let entity = EntityAffectation(context: self.managedObjectContext)
                entity.name = name
                entity.color = color
                
                self.anTreeController.rearrangeObjects()
                
                print("Done button tapped in Custom Sheet")
            case .cancel:
                
                print("Cancel button tapped in Custom Add Sheet")
            default:
                break
            }
            self.addModalWindowController = nil
        })
    }

    @IBAction func addChild(_ sender: Any) {
        
        let selected = anOutlineView.selectedRowIndexes.map { Int($0) }
        print(selected)
        
        var aff : EntityAffectation
        
        let item = anOutlineView.item(atRow: selected[0])
        let item1 = item as? NSTreeNode
        let item2 = item1?.representedObject as? NSManagedObject
        
        if item2 is EntityAffectation {
            aff = item2 as! EntityAffectation
        } else {
            let entity = item2 as! EntityCategory
            aff = entity.affectation!
        }

        self.addChildModalWindowController = AddChildModalWindowController(windowNibName: NSNib.Name(rawValue: "AddChildModalWindowController"))
        let windowAdd = addChildModalWindowController.window!
        let windowApp = self.window
        windowApp?.beginSheet( windowAdd, completionHandler: {(_ returnCode: NSApplication.ModalResponse) -> Void in
            
            print("Sheet closed")
            switch returnCode {
            case .OK:
                let name = self.addChildModalWindowController.name.stringValue
                print(name)
                let objectif = self.addChildModalWindowController.objectif.doubleValue
                print(objectif)
                
                let entity = EntityCategory(context: self.moc)
                entity.name = name
                entity.objectif = objectif
                entity.affectation = aff
                
                self.anTreeController.rearrangeObjects()


                print("Done button tapped in Custom Sheet")
            case .cancel:
                print("Cancel button tapped in Custom AddChild Sheet")
            default:
                break
            }
            self.addModalWindowController = nil
        })
        
    }
    
    @IBAction func remove(_ sender: Any) {
        
        let selected = anOutlineView.selectedRowIndexes.map { Int($0) }
        print(selected)

        let item = anOutlineView.item(atRow: selected[0])
        
        let item1 = item as? NSTreeNode
        let item2 = item1?.representedObject as? NSManagedObject

        if item2 is EntityAffectation {
            managedObjectContext.delete(item2!)
        } else {
            let entity = item2 as! EntityCategory
            let aff = entity.affectation
            aff?.removeFromCategory(entity)         // break just the link
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
}

class KSTableCellView2 : NSTableCellView {
    
    @IBOutlet weak var objectif:NSTextField!
}

