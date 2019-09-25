//
//  Alarm.swift
//  ClockApp
//
//  Created by Taylah Lucas on 25/9/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

class Alarm: NSObject {

    var hour: Int
    var minute: Int
    var time: Int
    var active: Bool
    
    required init(hour: Int, minute: Int, time: Int, active: Bool) {
        self.hour = hour
        self.minute = minute
        self.time = time
        self.active = active
    }
    
    // Set alarm to be inactive
    public func setActive() {
        
    }
}
