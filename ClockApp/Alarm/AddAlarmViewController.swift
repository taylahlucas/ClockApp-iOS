//
//  AddAlarmViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 24/9/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

// STACK VIEW: https://www.raywenderlich.com/2198310-uistackview-tutorial-for-ios-introducing-stack-views

import UIKit
import Foundation

class AddAlarmViewController: UIViewController {
    
    public var alarms: [Alarm] = []

    // Back button
    private let backButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(showAlarms), for: .touchUpInside)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()

    // Time picker
    private lazy var timePicker: UIDatePicker = {
        let picker: UIDatePicker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time

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
    
    // Remove alarms
    private lazy var removeAlarmsButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Remove all alarms", for: .normal)
        button.addTarget(self, action: #selector(removeAlarms), for: .touchUpInside)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    
    @objc func addAlarm() {
        // Format time
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm"
        let time: [String] = timeFormat.string(from: self.timePicker.date).components(separatedBy: ":")

        var newTime = time.compactMap { time in
            Int(time)
        }
        
        // Ensure all values have been converted correctly
        if (newTime.count == 2) {
            var type = "PM"
            if (newTime[0] >= 0 && newTime[0] <= 11) {
                type = "AM"
            } else if newTime[0] > 12 && newTime[0] <= 23 {
                newTime[0] -= 12
            }
            
            // Create alarm and add to UserDefaults
            let newAlarm = Alarm(hour: newTime[0], minute: newTime[1], type: type, active: false)
            alarms.append(newAlarm)
            do {
                let encodeData = try JSONEncoder().encode(alarms)
                UserDefaults.standard.set(encodeData, forKey: "alarms")
            } catch { print(error) }
            
            // Store alarm count
            let alarmCount: Int = alarms.count
            UserDefaults.standard.set(alarmCount, forKey: "alarmCount")
        }
    }
    
        // Show alarm objects
        @objc func showAlarms() {

        }
    
    // Remove all alarms
    @objc func removeAlarms() {
        alarms.removeAll()
        UserDefaults.standard.set(alarms.count, forKey: "alarmCount")
        /* DECISION -- Decided I want to keep an "alarms" in UserDefaults at all times as
         other view controllers access it */
        UserDefaults.standard.set(alarms, forKey: "alarms")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(backButton)
        view.addSubview(timePicker)
        view.addSubview(addAlarmButton)
        view.addSubview(removeAlarmsButton)
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        // Whole page
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            addAlarmButton.topAnchor.constraint(equalTo: timePicker.topAnchor, constant: 200),
            addAlarmButton.leftAnchor.constraint(equalTo: timePicker.leftAnchor, constant: 0),
            addAlarmButton.rightAnchor.constraint(equalTo: timePicker.rightAnchor, constant: 0),
            addAlarmButton.bottomAnchor.constraint(greaterThanOrEqualTo: timePicker.bottomAnchor, constant: 0),
            removeAlarmsButton.topAnchor.constraint(equalTo: timePicker.topAnchor, constant: 300),
            removeAlarmsButton.leftAnchor.constraint(equalTo: timePicker.leftAnchor, constant: 0),
            removeAlarmsButton.rightAnchor.constraint(equalTo: timePicker.rightAnchor, constant: 0),
            removeAlarmsButton.bottomAnchor.constraint(greaterThanOrEqualTo: timePicker.bottomAnchor, constant: 0)
        ])
    }
}
