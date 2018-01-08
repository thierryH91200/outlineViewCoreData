//
//  AddModalWindowController.swift
//  THOutlineViewCoreData
//
//  Created by thierryH24 on 08/01/2018.
//  Copyright © 2018 thierryH24. All rights reserved.
//

import Cocoa

class AddModalWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
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
