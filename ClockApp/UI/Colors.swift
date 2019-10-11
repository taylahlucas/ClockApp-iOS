//
//  Colors.swift
//  ClockApp
//
//  Created by Taylah Lucas on 11/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    // Converts string to hex color
    convenience init(hexString: String) {
        _ = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string:hexString as String)

        var color: UInt64 = 0
        scanner.charactersToBeSkipped = CharacterSet.init(charactersIn: "#")
        scanner.scanHexInt64(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    struct Palette {
        static let darkPurple = UIColor(hexString: "#0F0642")
        static let lightPurple = UIColor(hexString: "#8651F1")
        static let lightWhite = UIColor(hexString: "#EFEFEF")
    }
}

extension Color {
    var value: UIColor {
        var instanceColor = UIColor.clear

        switch self {
        case .darkBackground:
            instanceColor = UIColor.Palette.darkPurple
        case .lightBackground:
            instanceColor = UIColor.Palette.lightPurple
        case .lightText:
            instanceColor = UIColor.Palette.lightPurple
        case .whiteText:
            instanceColor = UIColor.Palette.lightWhite
        }
        return instanceColor
    }
}

enum Color {
    case darkBackground
    case lightBackground
    
    case lightText
    case whiteText
}

class UIColorScheme {
    func setViewColourScheme(for viewController: UIViewController) {
        viewController.view.backgroundColor = UIColor.Palette.darkPurple
    }
    
    func setTableColourScheme(for tableView: UITableView) {
        tableView.backgroundColor = Color.darkBackground.value
    }

    func setCellColourScheme(for cell: UITableViewCell) {
        cell.backgroundColor = Color.darkBackground.value
        cell.textLabel?.textColor = Color.lightBackground.value

        cell.layer.borderColor = Color.lightBackground.value.cgColor
    }
    
    func setAlarmCellColourScheme(for cell: AlarmTableViewCell) {
        cell.backgroundColor = UIColor.Palette.darkPurple
        cell.layer.borderColor = Color.lightBackground.value.cgColor
        cell.timeLabel.textColor = Color.lightText.value
        cell.typeLabel.textColor = Color.lightText.value
    }
    
    func setUnselectedButtonScheme(for button: UIButton) {
        button.backgroundColor = Color.darkBackground.value
        button.layer.borderColor = Color.lightBackground.value.cgColor
        button.setTitleColor(Color.lightText.value, for: .normal)
    }
    
    func setSelectedButtonScheme(for button: UIButton) {
        button.backgroundColor = Color.lightBackground.value
        button.setTitleColor(Color.whiteText.value, for: .normal)
        
    }

    static let instance = UIColorScheme()
}
