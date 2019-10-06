//
//  ViewController.swift
//  Damage Report Converter
//
//  Created by Jordan Smith on 10/4/19.
//  Copyright © 2019 Jordan Smith. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var fileLabel: NSTextField!
    @IBOutlet weak var convertButton: NSButton!
    @IBOutlet weak var completeLabel: NSTextField!
    var fileManager = FileManager()
    
    var fileName: String!
    var fullURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        convertButton.isEnabled = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            fileLabel.placeholderString = "No File Selected"
            fileLabel.stringValue = ""
        }
    }

    @IBAction func selectFileClicked(sender: AnyObject) {
        completeLabel.stringValue = ""
        let fileSelect = NSOpenPanel()
        fileSelect.title = "Select a Mercury Damage Report"
        fileSelect.allowsMultipleSelection = false
        fileSelect.canChooseDirectories = false
        fileSelect.allowedFileTypes = ["txt"]
        
        if (fileSelect.runModal() == NSApplication.ModalResponse.OK )
        {
            
            if (fileSelect.urls.count > 0) {
                fileName = fileSelect.urls[0].lastPathComponent
                fullURL = fileSelect.urls[0]
                fileLabel.stringValue = fileName
                convertButton.isEnabled = true
            }
        }
    }
    @IBAction func convertClicked(sender: AnyObject) {
        completeLabel.stringValue = "Processing..."
        var newFile = ""
        var newFileName = fullURL.deletingLastPathComponent().path
        var count = 1
        //var firstLine = true
        
        if fileManager.fileExists(atPath: fullURL.path) {
            do {
                let fileData = try String(contentsOf: fullURL)
                let stringData = fileData.components(separatedBy: .newlines)
                
                for line in stringData {
                    let lineParts = line.split(separator: ";")
                    for step in lineParts {
                        newFile.append("Step " + String(count) + ":\n")
                        count += 1
                        newFile.append(String(step) + "\n")
                    }
                }
            }
            catch {
                print(error)
                completeLabel.stringValue = "Error in file"
                return
            }
            var fileNoExtension = fileName
            for var i in (0...3) {
                fileNoExtension?.removeLast()
                i += 1
            }
            newFileName += "/" + fileNoExtension! + "_Thorium.txt"
            let newFileURL = URL(fileURLWithPath: newFileName)
            let newFileData = newFile.data(using: .utf8)
            do {
                try newFileData?.write(to: newFileURL)
            }
            catch {
                print(error)
                completeLabel.stringValue = "Error converting file"
                return
            }
            
            completeLabel.stringValue = "Done!"
        }
    }

}

