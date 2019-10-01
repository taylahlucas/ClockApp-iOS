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
    public let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "1"
        
        return label
    }()
   
    // Defines alarm cell button
    public let activateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(activateAlarm), for: .touchUpInside)
        
        return button
    }()
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        
        addSubview(timeLabel)
        addSubview(activateButton)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 50),
            timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -50),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            activateButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            activateButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            activateButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            activateButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    @objc func activateAlarm() {
        print("ALARM ACTIVATED")
    }
    
    public func setTitle(title: String) {
        timeLabel.text = title
    }
}
