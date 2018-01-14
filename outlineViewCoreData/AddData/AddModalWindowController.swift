/**
 @file      AddModalWindowController.swift
 @author    thierryH24
 @date      08/01/2018

 Copyright 2018 thierryH24

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

class AddModalWindowController: NSWindowController {
    
    @IBOutlet weak var affectation: NSButton!
    
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var colorWell: NSColorWell!
    
    @IBOutlet weak var cancel: NSButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        affectation.title = "Affectation"
        affectation.bezelStyle = .texturedSquare
        affectation.isBordered = false //Important
        affectation.wantsLayer = true
        affectation.layer?.backgroundColor = NSColor.orange.cgColor
        
        if cancel.acceptsFirstResponder {
            self.window?.makeFirstResponder(cancel)
        }
    }

    @IBAction func didTapCancelButton(_ sender: Any ) {
        window?.sheetParent?.endSheet(window!, returnCode: .cancel)
        self.window!.close()
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        window?.sheetParent?.endSheet(window!, returnCode: .OK )
        self.window!.close()
    }

}
