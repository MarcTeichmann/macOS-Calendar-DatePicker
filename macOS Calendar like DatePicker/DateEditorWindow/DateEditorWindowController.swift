//
//  DateEditorWindowController.swift
//  macOS Calendar like DatePicker
//
//  Created by Marc Teichmann on 11.06.18.
//  Copyright © 2018 Celmaro. All rights reserved.
//

import Cocoa

protocol DateEditorWindowControllerDelegate {
    
    func dateEditorWindowDidOpen( window:NSWindow)
    func dateEditorWindowDidClose( window:NSWindow)
    func dateEditorValueDidChange( dateValue:Date)
    
}

class DateEditorWindowController: NSWindowController {
    
    @IBOutlet weak var datePicker: NSDatePicker!
    
    @IBAction func datePickerAction(_ sender: NSDatePicker) {
    
        // forward action to accessibility date picker
        delegate?.dateEditorValueDidChange(dateValue: sender.dateValue)
    }
    
    static let sharedWindowController = DateEditorWindowController()
    var delegate:DateEditorWindowControllerDelegate?
    private var localMouseDownEventMonitor:Any?
    

    override var windowNibName: NSNib.Name?{
        return NSNib.Name("DateEditorWindowController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
    }
    
    func presentFor(controlView:NSView){
        
        guard let dateEditorWindow = self.window else {return}
        
        let parentWindow = controlView.window
        let parentFrame = controlView.frame
        
        var locationRect = controlView.superview?.convert(parentFrame, to: nil)
        locationRect = parentWindow?.convertToScreen(locationRect!)
        locationRect?.origin.y += 20.0
        
        dateEditorWindow.setFrameTopLeftPoint(NSPoint(x: (locationRect?.origin.x)!, y: (locationRect?.origin.y)!))
        parentWindow?.addChildWindow(dateEditorWindow, ordered: NSWindow.OrderingMode.above)
        dateEditorWindow.makeKeyAndOrderFront(nil)
        
        delegate?.dateEditorWindowDidOpen(window: dateEditorWindow)
        // needs to be delayed not to ignore initial mouse event
        perform(#selector(register), with: nil, afterDelay: 0.1)
        //register()
    }
    
    func removeWindow(){
        
        unRegister()
        
        if let dateEditorWindow = window {
            
            if let mainWindow = dateEditorWindow.parent {
                mainWindow.removeChildWindow(dateEditorWindow)
                dateEditorWindow.orderOut(nil)
                mainWindow.makeFirstResponder(nil)
            }
        }
        
        delegate?.dateEditorWindowDidClose(window: window!)
        
    }
    
    @objc func register(){
        
        
        // window?.parent?.discardEvents(matching: [.leftMouseUp, .rightMouseDown,.otherMouseDown], before: nil)
        localMouseDownEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseUp, .rightMouseDown,.otherMouseDown]) { incommingEvent -> NSEvent? in
            
            if incommingEvent.window != self.window {
                
                self.removeWindow()
            }
            return incommingEvent
        }
    }
    
    func unRegister() {
        
        if let monitor = localMouseDownEventMonitor{
            
            NSEvent.removeMonitor(monitor)
            localMouseDownEventMonitor = nil
        }
    }
}

