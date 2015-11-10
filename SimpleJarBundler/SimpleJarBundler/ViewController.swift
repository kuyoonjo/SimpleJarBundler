//
//  ViewController.swift
//  SimpleJarBundler
//
//  Created by Yu Chen on 10/23/15.
//  Copyright © 2015 Yu Chen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var bundleName: NSTextField!
    @IBOutlet weak var version: NSTextField!
    @IBOutlet weak var jarPath: NSTextField!
    @IBOutlet weak var mainClass: NSTextField!
    @IBOutlet weak var iconFile: NSTextField!
    @IBOutlet weak var resourcePath: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func jarPathPopup(sender: AnyObject) {
        let jarPathPicker:NSOpenPanel = NSOpenPanel()
        jarPathPicker.allowsMultipleSelection = false
        jarPathPicker.canChooseFiles = true
        
        if(jarPathPicker.runModal() == NSModalResponseOK) {
            jarPath.stringValue = (jarPathPicker.URL?.path)!
        }
    }
    @IBAction func iconFilePopup(sender: AnyObject) {
        let iconFilePicker = NSOpenPanel()
        iconFilePicker.allowsMultipleSelection = false
        iconFilePicker.canChooseFiles = true
        iconFilePicker.allowedFileTypes = ["icns"]
        if(iconFilePicker.runModal() == NSModalResponseOK) {
            iconFile.stringValue = (iconFilePicker.URL?.path)!
        }
    }

    @IBAction func resourcePathPopup(sender: AnyObject) {
        let resourcePicker:NSOpenPanel = NSOpenPanel()
        resourcePicker.allowsMultipleSelection = false
        resourcePicker.canChooseFiles = false
        resourcePicker.canChooseDirectories = true
        
        if(resourcePicker.runModal() == NSModalResponseOK) {
            resourcePath.stringValue = (resourcePicker.URL?.path)!
        }
    }
    
    @IBAction func mainClassHelp(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://docs.oracle.com/javase/tutorial/deployment/jar/appman.html")!)
    }
    
    @IBAction func create(sender: AnyObject) {
        let filePicker:NSSavePanel = NSSavePanel()
        filePicker.showsTagField = false
        filePicker.allowedFileTypes = ["app"]
        filePicker.nameFieldStringValue = bundleName.stringValue
        if(filePicker.runModal() == NSModalResponseOK) {
            let output:String = (filePicker.URL?.path!)!
            sjb(output, CFBundleName: bundleName.stringValue, CFBundleShortVersionString: version.stringValue, CFBundleIconFile: iconFile.stringValue, JarFile: jarPath.stringValue, MainClass: mainClass.stringValue, resource: resourcePath.stringValue)
        } else {
            print("cancelled")
        }
        
        
    }
    
    private func sjb(
        output:String,
        CFBundleName:String,
        CFBundleShortVersionString:String,
        CFBundleIconFile:String,
        JarFile:String,
        MainClass:String,
        resource:String) {
            let task: NSTask = NSTask()
            task.launchPath = "/usr/bin/perl"
            let bundle = NSBundle.mainBundle()
            let rpath:String = bundle.resourcePath!
            let script:String = rpath + "/sjb.pl"
            task.arguments = [script, output, rpath ,CFBundleName, CFBundleShortVersionString, CFBundleIconFile, JarFile, MainClass, resource]
            task.launch()
            task.waitUntilExit()
    }
}

