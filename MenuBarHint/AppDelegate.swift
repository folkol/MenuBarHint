//
//  AppDelegate.swift
//  MenuBarExtra
//
//  Created by Mattias Johansson on 2022-06-29.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private let MAX_ITEMS = 3

    @IBOutlet var window: NSWindow!

    // sort them?
    // file monitor instead of polling?
    @objc func pollFolder() {
        if let button = statusItem.button {
            let fileManager = FileManager.default
            let documentsURL =  fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let appSupport = documentsURL.appendingPathComponent("Memento")

            do
            {
                try FileManager.default.createDirectory(atPath: appSupport.path, withIntermediateDirectories: true, attributes: nil)
                let items = try FileManager.default.contentsOfDirectory(atPath: appSupport.path)
                var title = items.prefix(MAX_ITEMS).joined(separator: " | ")
                if items.count > MAX_ITEMS {
                    title += " (+\(items.count - MAX_ITEMS))"
                }
                button.title = title
            }
            catch
            {
                NSLog("Unexpected error accessing Application Support: \(error)")
            }
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(pollFolder), userInfo: nil, repeats: true)
    }
}
