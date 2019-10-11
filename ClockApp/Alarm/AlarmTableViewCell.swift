//
//  AlarmTableViewCell.swift
//  ClockApp
//
//  Created by Taylah Lucas on 1/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

struct AlarmCell: Codable {
    let timeLabel: String
    let activate: Bool
}

class AlarmTableViewCell: UITableViewCell {
    // Defines alarm cell time
    public let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left

        return label
    }()
    
    // Represents AM or PM
    public let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
 
        return label
    }()
   
    // Defines alarm cell switch
    public let activateAlarmSwitch: UISwitch = {
        let swi = UISwitch()
        swi.translatesAutoresizingMaskIntoConstraints = false

        return swi
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(typeLabel)
        self.contentView.addSubview(activateAlarmSwitch)
        
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            typeLabel.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: -5),
            typeLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 5),
            activateAlarmSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            activateAlarmSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
