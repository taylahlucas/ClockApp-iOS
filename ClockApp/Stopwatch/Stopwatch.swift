//
//  Stopwatch.swift
//  ClockApp
//
//  Created by Taylah Lucas on 2/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

enum StopwatchKey: String {
    case timer
    case lap
}

struct Stopwatch: Codable {
    let hour: String
    let min: String
    let sec: String
}

class VariableStopwatch {
    var hour: Int
    var min: Int
    var sec: Int
    
    init(hour: Int, min: Int, sec: Int) {
        self.hour = hour
        self.min = min
        self.sec = sec
    }
    
    func increaseTime() {
        
    }

}
