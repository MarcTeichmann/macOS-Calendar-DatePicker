//
//  CustomDatePicker.swift
//  macOS Calendar like DatePicker
//
//  Created by Marc Teichmann on 11.06.18.
//  Copyright © 2018 Celmaro. All rights reserved.
//

import Cocoa


class CustomDatePicker: NSDatePicker {
    
    
    var accessibilityWindowController:DateEditorWindowController?
    var dummyView:NSView?
    var proposedNextKeyView:NSView?

    // forward action to accessibility date picker
    override func sendAction(_ action: Selector?, to target: Any?) -> Bool {
    
        accessibilityWindowController?.datePicker.dateValue = self.dateValue
        return super.sendAction(action, to: target)
    }
    
    // support Return and ESC ketCodes
    override func keyDown(with event: NSEvent) {
        
        let keyCode = event.keyCode
        if accessibilityWindowController != nil && ( keyCode == 53 || keyCode == 36 ){
            
            proposedNextKeyView = self
            accessibilityWindowController?.removeWindow()
            
        } else if keyCode == 36 {
            openAccessibilityWindow()
        } else {
            super.keyDown(with: event)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        
        if accessibilityWindowController == nil {
            openAccessibilityWindow()
        } else{
            super.mouseDown(with: event)
        }
    }

    
    override var nextValidKeyView: NSView? {
        
        if let controller = accessibilityWindowController {
            
            proposedNextKeyView = super.nextValidKeyView
            controller.removeWindow()
            
            return nil
        } else {
            return super.nextValidKeyView
        }
    }
    
    override var previousValidKeyView: NSView? {
        
        if let controller = accessibilityWindowController{
            
            proposedNextKeyView = super.previousValidKeyView
            controller.removeWindow()
            return nil
            
        } else {
            return super.nextValidKeyView
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        
        //window?.discardEvents(matching: NSEvent.EventTypeMask.leftMouseDown, before: nil)
        print("becomeFirstResponder")
        let result = super.becomeFirstResponder()
        openAccessibilityWindow()

        return result
    }
    
    func openAccessibilityWindow()  {
        
        if accessibilityWindowController != nil {
            return
        }
        
        accessibilityWindowController = DateEditorWindowController.sharedWindowController
        accessibilityWindowController?.delegate = self
        accessibilityWindowController?.presentFor(controlView: self)
        
    }
    
}

extension CustomDatePicker: DateEditorWindowControllerDelegate {
    
    func dateEditorWindowDidOpen( window: NSWindow) {
        
        dummyView = NSView(frame: self.frame)
        self.superview?.addSubview(dummyView!)
        
        removeFromSuperview()
        window.contentView?.addSubview(self)
        setFrameOrigin(NSPoint(x: 0.0, y: 148.0))
        window.makeFirstResponder(self)
        
    }
    
    func dateEditorWindowDidClose(window: NSWindow) {
        
        let mainView = dummyView?.superview
        removeFromSuperview()
        self.frame = (dummyView?.frame)!
        mainView?.addSubview(self)
        dummyView?.removeFromSuperview()
        
        if let nc = proposedNextKeyView {
            self.window?.makeFirstResponder(nc)
            proposedNextKeyView = nil
            
        }
        
        accessibilityWindowController = nil
    }
    
    func dateEditorValueDidChange(dateValue: Date) {
        self.dateValue = dateValue
    }
    
}
