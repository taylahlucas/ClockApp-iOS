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
                UserDefaults.standard.set(encodeData, forKey: AlarmKey.alarms.rawValue)
            } catch { print(error) }
            
            // Store alarm count
            let alarmCount: Int = alarms.count
            UserDefaults.standard.set(alarmCount, forKey: AlarmKey.alarmCount.rawValue)
            
            // Navigate back to show alarms page upon completion
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(timePicker)
        view.addSubview(addAlarmButton)
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Read alarms from user defaults
        if let alarmData = UserDefaults.standard.object(forKey: AlarmKey.alarms.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let allAlarms = try? decoder.decode([Alarm].self, from: alarmData) {
                alarms = allAlarms
            }
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            addAlarmButton.topAnchor.constraint(equalTo: timePicker.topAnchor, constant: 300),
            addAlarmButton.centerXAnchor.constraint(equalTo: timePicker.centerXAnchor)
        ])
    }
}
