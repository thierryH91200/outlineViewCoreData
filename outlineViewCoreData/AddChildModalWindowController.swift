//
//  AddChildModalWindowController.swift
//  THOutlineViewCoreData
//
//  Created by thierryH24 on 08/01/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//

import Cocoa

class AddChildModalWindowController: NSWindowController {
    
    @IBOutlet weak var category: NSButton!
    
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var objectif: NSTextField!
    
    @IBOutlet weak var cancel: NSButton!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        category.title = "Category"
        category.bezelStyle = .texturedSquare
        category.isBordered = false //Important
        category.wantsLayer = true
        category.layer?.backgroundColor = NSColor.green.cgColor
        
        if cancel.acceptsFirstResponder {
            self.window?.makeFirstResponder(cancel)
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        window?.sheetParent?.endSheet(window!, returnCode: .cancel)
        self.window!.close()
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        window?.sheetParent?.endSheet(window!, returnCode: .OK)
        self.window!.close()
    }

}
