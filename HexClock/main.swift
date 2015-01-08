//
//  AppDelegate.swift
//  HexClock
//
//  Created by Daniel Höpfl on 08.01.2015.
//  Copyright (c) 2015 Daniel Höpfl. All rights reserved.
//

import Cocoa

class HexClock : NSObject {

    var windows : [NSWindow] = []

    override init() {
        super.init()

        NSNotificationCenter.defaultCenter().addObserverForName(NSApplicationDidChangeScreenParametersNotification, object: NSApplication.sharedApplication(), queue: NSOperationQueue.mainQueue()) { (x) -> Void in
            self.updateScreens()
        }
        updateScreens()
    }

    func tick() {
        let now = NSDate()

        let cal = NSCalendar.currentCalendar()
        let components = cal.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: now)
        // NSLog("%02d:%02d:%02d", components.hour, components.minute, components.second)
        for window in windows {
            window.backgroundColor = NSColor(deviceRed: CGFloat(components.hour)/255, green: CGFloat(components.minute)/255, blue: CGFloat(components.second), alpha: 1.0)

            let timeIntervalSinceReferenceDate = now.timeIntervalSinceReferenceDate
            let to : NSTimeInterval = 1 - (timeIntervalSinceReferenceDate - NSTimeInterval(Int(timeIntervalSinceReferenceDate)))
            NSTimer.scheduledTimerWithTimeInterval(to, target: self, selector: "tick", userInfo: nil, repeats: false)
        }
    }

    func updateScreens() {
        windows.removeAll()

        let screens = NSScreen.screens() as [NSScreen]
        for screen in screens {
            let window = NSWindow(contentRect: screen.frame, styleMask: NSBorderlessWindowMask, backing: .Buffered, defer: true)
            window.level = Int(CGWindowLevelForKey(Int32(kCGDesktopWindowLevelKey)))
            window.backgroundColor = NSColor.clearColor()
            window.orderFrontRegardless()

            windows.append(window)
        }
        tick()
    }

}

HexClock()
NSApplication.sharedApplication().run()
