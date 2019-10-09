//
//  Alarm.swift
//  ClockApp
//
//  Created by Taylah Lucas on 25/9/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

struct Alarm: Codable {
    let time: DateComponents
    let type: String
    var active: Bool
}
