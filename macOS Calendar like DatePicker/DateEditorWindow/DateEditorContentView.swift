//
//  DateEditorBackgroundView.swift
//  macOS Calendar like DatePicker
//
//  Created by Marc Teichmann on 11.06.18.
//  Copyright © 2018 Celmaro. All rights reserved.
//

import Cocoa

class DateEditorContentView: NSView {

    var path:NSBezierPath {
        
        let rect = bounds 
        let left = rect.origin.x
        let right = rect.origin.x + rect.size.width
        let top = rect.origin.y + rect.size.height
        let bottom = rect.origin.y
        
        let corner:CGFloat = 6.0
        let notchX:CGFloat = 80.0
        let notchY:CGFloat = 22.0
        
        let thePath = NSBezierPath()
        thePath.move(to: NSPoint(x: left + corner, y: top))
        thePath.line(to: NSPoint(x: left + (notchX - 17), y: top))
        thePath.curve(to: NSPoint(x: left + notchX, y: top - corner), controlPoint1: NSPoint(x: left + notchX, y: top), controlPoint2: NSPoint(x: left + notchX, y: top))
        thePath.line(to: NSPoint(x: left + notchX, y: top - (notchY - corner)))
        thePath.curve(to: NSPoint(x: left + (notchX + corner), y: top - notchY), controlPoint1: NSPoint(x: left + notchX, y: top - notchY), controlPoint2: NSPoint(x: left + notchX, y: top - notchY))
        thePath.line(to: NSPoint(x: right - corner, y: top - notchY))
        thePath.curve(to: NSPoint(x: right, y: top - (notchY + corner)), controlPoint1: NSPoint(x: right, y: top - notchY), controlPoint2: NSPoint(x: right, y: top - notchY))
        thePath.line(to: NSPoint(x: right, y: bottom + corner))
        thePath.curve(to: NSPoint(x: right - corner, y: bottom), controlPoint1: NSPoint(x: right, y: bottom), controlPoint2: NSPoint(x: right, y: bottom))
        thePath.line(to: NSPoint(x: left + corner , y: bottom ))
        thePath.curve(to: NSPoint(x: left, y: bottom + corner), controlPoint1: NSPoint(x: left, y: bottom), controlPoint2: NSPoint(x: left, y: bottom))
        thePath.line(to: NSPoint(x: left, y:top - corner ))
        thePath.curve(to: NSPoint(x: left + corner, y: top), controlPoint1: NSPoint(x: left, y: top), controlPoint2: NSPoint(x: left, y: top))
        
        return thePath
    }
    
    override func draw(_ dirtyRect: NSRect) {

        super.draw(dirtyRect)
        NSColor.white.setFill()
        path.fill()
   
    }
}
