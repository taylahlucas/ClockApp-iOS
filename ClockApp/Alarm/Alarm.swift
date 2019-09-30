//
//  Alarm.swift
//  ClockApp
//
//  Created by Taylah Lucas on 25/9/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

struct Alarms: Codable {
    var alarms: [Alarm]
}

struct Alarm: Codable {
    var hour: Int
    var minute: Int
    var type: String
    var active: Bool
}

//class Alarm: NSObject {
//
//    var hour: Int = 0
//    var minute: Int = 0
//    var type: String = ""
//    var active: Bool = false
//
//    init(hour: Int, minute: Int, type: String, active: Bool) {
//        self.hour = hour
//        self.minute = minute
//        self.type = type
//        self.active = active
//    }
//
////    init(coder decoder: NSCoder) {
////        self.hour = decoder.decodeInteger(forKey: "hour")
////        self.minute = decoder.decodeInteger(forKey: "minute")
////        self.type = decoder.decodeObject(forKey: "type") as! String
////        self.active = (decoder.decodeObject(forKey: "active") != nil)
////    }
////
////    func encodeWithCoder(coder: NSCoder) {
////        coder.encode(hour, forKey: "hour")
////        coder.encode(minute, forKey: "minute")
////        coder.encode(type, forKey: "type")
////        coder.encode(active, forKey: "active")
////    }
//
//    // Set alarm to be inactive
//    public func setActive() {
//
//    }
//}
