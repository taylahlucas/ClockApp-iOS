//
//  Fonts.swift
//  ClockApp
//
//  Created by Taylah Lucas on 11/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
//    convenience init(name: String, size: CGFloat) {
//        self.init(name: name, size: size)         // This gives errors ?
//    }
    struct Fonts {
        static let heading = UIFont(name: "Arial", size: 30)
        static let subHeading = UIFont(name: "Arial", size: 24)
        static let description = UIFont(name: "Arial", size: 18)
    }
}

extension Font {
    var value: UIFont {
        var instanceFont = UIFont.init()

        switch self {
        case .heading:
            instanceFont = UIFont.Fonts.heading!   // How to get around force unwrapping ??
        case .subHeading:
            instanceFont = UIFont.Fonts.subHeading!
        case .description:
            instanceFont = UIFont.Fonts.description!
        }
        
        return instanceFont
    }
}

enum Font {
    case heading
    case subHeading
    case description
}

class UIFontScheme {
    func setCellFont(for cell: UITableViewCell) {
        cell.textLabel?.font = UIFont.Fonts.heading
    }
    
    func setAlarmCellFont(for cell: AlarmTableViewCell) {
        cell.timeLabel.font = UIFont.Fonts.heading
        cell.typeLabel.font = UIFont.Fonts.description
    }

    static let instance = UIFontScheme()
}
