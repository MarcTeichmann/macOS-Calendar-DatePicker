//
//  TransparentEditorWindow.swift
//  macOS Calendar like DatePicker
//
//  Created by Marc Teichmann on 11.06.18.
//  Copyright © 2018 Celmaro. All rights reserved.
//

import Cocoa

class DateEditorWindow: NSWindow {
 
    override var canBecomeKey: Bool {
        return true
    }

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        
        // Regardless of what is passed via the styleMask paramenter, always create a NSBorderlessWindowMask window
        super.init(contentRect: contentRect, styleMask: NSWindow.StyleMask.borderless, backing: backingStoreType, defer: flag)

        hasShadow = true
        backgroundColor = NSColor.clear
        isOpaque = false
    
    }
}
