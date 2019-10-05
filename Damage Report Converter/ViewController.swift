//
//  ViewController.swift
//  Damage Report Converter
//
//  Created by Jordan Smith on 10/4/19.
//  Copyright © 2019 Jordan Smith. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var FileLabel: NSTextField!
    
    var fullPath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func selectFileClicked(sender: AnyObject) {
        let fileSelect = NSOpenPanel()
        fileSelect.title = "Select a Mercury Damage Report"
        fileSelect.allowsMultipleSelection = false
        fileSelect.canChooseDirectories = false
        fileSelect.allowedFileTypes = ["txt"]
        
        if (fileSelect.runModal() == NSApplication.ModalResponse.OK )
        {
            
            if (fileSelect.urls.count > 0) {
                let file = fileSelect.urls[0].lastPathComponent
                fullPath = fileSelect.urls[0].absoluteString
                FileLabel.stringValue = file
            }
        }
    }

}

