//
//  Alarm.swift
//  ClockApp
//
//  Created by Taylah Lucas on 25/9/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

struct AlarmCell: Codable {
    let timeLabel: String
    let activate: Bool
}

struct Alarm: Codable {
    let time: DateComponents
    var active: Bool
}

enum AlarmKey: String {
    case alarms
    case alarmCount
}
