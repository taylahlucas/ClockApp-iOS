//
//  Scheme.swift
//  ClockApp
//
//  Created by Taylah Lucas on 11/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import Foundation
import UIKit

class UIScheme {
    func setViewScheme(for viewController: UIViewController) {
        UIColorScheme.instance.setViewColourScheme(for: viewController)
    }
    
    func setTableScheme(for table: UITableView) {
        UIColorScheme.instance.setTableColourScheme(for: table)
    }
    
    func setCellScheme(for cell: UITableViewCell) {
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2
        cell.layer.borderWidth = 0.5
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        
        UIColorScheme.instance.setCellColourScheme(for: cell)
        UIFontScheme.instance.setCellFont(for: cell)
    }
    
    func setAlarmCellScheme(for cell: AlarmTableViewCell) {
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2
        cell.layer.borderWidth = 0.5
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)

        UIColorScheme.instance.setAlarmCellColourScheme(for: cell)
        UIFontScheme.instance.setAlarmCellFont(for: cell)
    }
    
    func setButtonScheme(for button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.5
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
        button.clipsToBounds = true

        UIColorScheme.instance.setUnselectedButtonScheme(for: button)
    }
    
    static let instance = UIScheme()
}
