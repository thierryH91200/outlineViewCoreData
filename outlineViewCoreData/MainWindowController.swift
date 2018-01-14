/**
 @file      MainWindowController.swift
 @author    thierryH91200
 @date      29/12/2017

 Copyright 2017 till 2018 thierryH91200

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

import Cocoa

class MainWindowController: NSWindowController, NSOutlineViewDelegate  {
    
    @IBOutlet weak var anOutlineView: NSOutlineView!
    @IBOutlet var anTreeController: NSTreeController!
    
    var dragType = [NSPasteboard.PasteboardType]()
    var draggedNode:Any? = nil
    
    @objc var managedObjectContext: NSManagedObjectContext = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    
    func outlineViewSelectionDidChange(_ notification: Notification)
    {
        let index = anOutlineView.selectedRow
        let rowView = anOutlineView.rowView(atRow: index, makeIfNecessary: false)
        rowView?.isEmphasized = true
    }

    
//    override func copy(_ sender: Any){
//
//        var textToDisplayInPasteboard = ""
//        let indexSet = anOutlineView.selectedRowIndexes
//        for (_, rowIndex) in indexSet.enumerated() {
////            var iterator: CoreDataOjectType
////            var iterator = anOutlineView.item(atRow: rowIndex)
////            textToDisplayInPasteboard = (iterator.name)!
////            print(iterator.name)
//        }
//        let pasteBoard = NSPasteboard.general
//        pasteBoard.clearContents()
//        pasteBoard.setString(textToDisplayInPasteboard, forType:NSPasteboard.PasteboardType.string)
//
//    }
    
}

extension MainWindowController: NSTextFieldDelegate {
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        
        anTreeController.rearrangeObjects()
    }
}



