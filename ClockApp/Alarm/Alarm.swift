//
//  Alarm.swift
//  ClockApp
//
//  Created by Taylah Lucas on 25/9/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

struct Alarm: Codable {
    var hour: Int
    var minute: Int
    var type: String
    var active: Bool
}