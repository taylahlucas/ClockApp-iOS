//
//  AlarmTableViewCell.swift
//  ClockApp
//
//  Created by Taylah Lucas on 1/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit


class AlarmTableViewCell: UITableViewCell {

    // Sets the values for the alarm cell
    var alarm: AlarmCell? {
        didSet {
            timeLabel.text = alarm?.timeLabel
        }
    }
    // Defines alarm cell time
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left

        return label
    }()
   
    // Defines alarm cell button
    public let activateButton: UISwitch = {
        let button = UISwitch()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(activateAlarm), for: .touchUpInside)
        
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(timeLabel)
        
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            timeLabel.widthAnchor.constraint(equalToConstant: frame.size.width/2),
//            timeLabel.heightAnchor.constraint(equalToConstant: 0)
//            activateButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//            activateButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
//            activateButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
//            activateButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    @objc func activateAlarm(sender: UISwitch!) {
        sender.isOn
    }
    
    public func updateCell(with data: AlarmCell) {
        self.timeLabel.text = data.timeLabel
        
    }

}
