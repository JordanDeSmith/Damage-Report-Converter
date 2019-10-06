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
    @IBOutlet weak var conversionSelector: NSPopUpButton!
    var fileManager = FileManager()
    
    var URLs: [URL]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        convertButton.isEnabled = false
        conversionSelector.removeAllItems()
        conversionSelector.addItem(withTitle: "Mercury->Thorium")
        conversionSelector.addItem(withTitle: "Missing Colons")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            fileLabel.placeholderString = "No File Selected"
            fileLabel.stringValue = ""
        }
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Converter"
    }

    @IBAction func selectFileClicked(sender: AnyObject) {
        completeLabel.stringValue = ""
        let fileSelect = NSOpenPanel()
        fileSelect.allowsMultipleSelection = true
        fileSelect.canChooseDirectories = false
        fileSelect.allowedFileTypes = ["txt"]
        
        if (fileSelect.runModal() == NSApplication.ModalResponse.OK )
        {
            
            if (fileSelect.urls.count > 0) {
                URLs = fileSelect.urls
                convertButton.isEnabled = true
                var files = ""
                for file in fileSelect.urls {
                    files += String(file.lastPathComponent) + "\n"
                }
                fileLabel.stringValue = files
            }
        }
    }
    
    @IBAction func conversionChange(_ sender: Any) {
        completeLabel.stringValue = ""
    }
    
    func processFile(fullURL: URL, newFolder: String)
    {
        var newFile = ""
        var newFileName = newFolder
        var count = 1
        
        if fileManager.fileExists(atPath: fullURL.path) {
            do {
                let fileData = try String(contentsOf: fullURL)
                let stringData = fileData.components(separatedBy: .newlines)
                
                for line in stringData {
                    if conversionSelector.titleOfSelectedItem == "Mercury->Thorium" {
                        
                        let lineParts = line.split(separator: ";")
                        for step in lineParts {
                            newFile.append("Step " + String(count) + ":\n")
                            count += 1
                            newFile.append(String(step) + "\n")
                        }
                    }
                    else if conversionSelector.titleOfSelectedItem == "Missing Colons" {
                            print("Removing colons")
                        }
                    }
                }
            catch {
                print(error)
                completeLabel.stringValue = "Error in file"
                return
            }
            var fileNoExtension = String?(fullURL.lastPathComponent)
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
        }
    }
    
    @IBAction func convertClicked(sender: AnyObject) {
        completeLabel.stringValue = "Processing..."
        var newFolder = URLs[0].deletingLastPathComponent().path
        if URLs.count > 1 {  //Multiple files, create folder for results
            newFolder += "/Thorium_Ready"
            do {
                try FileManager.default.createDirectory(atPath: newFolder, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print(error)
            }
        }
        for file in URLs {
            processFile(fullURL: file, newFolder: newFolder)
        }
            
        completeLabel.stringValue = "Done!"
        }
    }

