//
//  AddAlarmViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 24/9/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit
import Foundation

class AddAlarmViewController: UIViewController {
    
    public var alarms: [Alarm] = []

    // Time picker
    private lazy var timePicker: UIDatePicker = {
        let picker: UIDatePicker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")

        return picker
    }()

    // Button to add alarm
    private lazy var addAlarmButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Alarm", for: .normal)
        button.addTarget(self, action: #selector(addAlarm), for: .touchUpInside)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(timePicker)
        view.addSubview(addAlarmButton)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            addAlarmButton.topAnchor.constraint(equalTo: timePicker.topAnchor, constant: 300),
            addAlarmButton.centerXAnchor.constraint(equalTo: timePicker.centerXAnchor)
        ])
    }
    
    @objc func addAlarm() {
        let time = Calendar.current.dateComponents([.hour, .minute], from: self.timePicker.date)
        
        var type = "PM"
        if (0..<12).contains(time.hour ?? 0) {
            type = "AM"
        }
        
        // Create alarm and add to UserDefaults
        let newAlarm = Alarm(time: time, type: type, active: false)
        alarms.append(newAlarm)
        
        do {
            let encodeData = try JSONEncoder().encode(alarms)
            UserDefaults.standard.set(encodeData, forKey: AlarmKey.alarms.rawValue)
        } catch { print(error) }
}
