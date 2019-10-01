//
//  AlarmTableViewCell.swift
//  ClockApp
//
//  Created by Taylah Lucas on 1/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit


class AlarmTableViewCell: UITableViewCell {

    // Defines alarm cell time
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left

        return label
    }()
   
    // Defines alarm cell switch
    public let activateAlarmSwitch: UISwitch = {
        let swi = UISwitch()
        swi.translatesAutoresizingMaskIntoConstraints = false
        swi.addTarget(self, action: #selector(activateAlarm), for: .touchUpInside)
        
        return swi
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(activateAlarmSwitch)
        
        setupLayout()
    }
    
    func setupLayout() {
        // TO DO-- need to centerY UIswitch
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            activateAlarmSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            activateAlarmSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // Set alarm on or off
    @objc func activateAlarm(sender: UISwitch!) {
        if (sender.isOn) {

        }
    }
    
    // Update cell value
    public func updateCell(with data: AlarmCell) {
        self.timeLabel.text = data.timeLabel
        self.activateAlarmSwitch.isOn = data.activate
    }

}
