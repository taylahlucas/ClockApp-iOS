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
    
    public var allAlarms: [Alarm] = []

    // Time picker
    private lazy var timePicker: UIDatePicker = {
        let picker: UIDatePicker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.backgroundColor = Color.lightBackground.value
        picker.setValue(Color.lightText.value, forKey: "textColor")

        return picker
    }()

    // Button to add alarm
    private lazy var addAlarmButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Add Alarm", for: .normal)
        button.addTarget(self, action: #selector(addAlarm), for: .touchUpInside)
        UIScheme.instance.setButtonScheme(for: button)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        decodeAlarms()
    }
    
    private func setupLayout() {
        UIScheme.instance.setViewScheme(for: self)
        UIColorScheme.instance.setUnselectedButtonScheme(for: addAlarmButton)
        
        view.addSubview(timePicker)
        view.addSubview(addAlarmButton)
        
        NSLayoutConstraint.activate([
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            addAlarmButton.topAnchor.constraint(equalTo: timePicker.topAnchor, constant: 300),
            addAlarmButton.centerXAnchor.constraint(equalTo: timePicker.centerXAnchor)
        ])
    }
    
    @objc func addAlarm() {
        UIColorScheme.instance.setSelectedButtonScheme(for: addAlarmButton)
        let time = Calendar.current.dateComponents([.hour, .minute], from: self.timePicker.date)
        
        var type = "PM"
        if (0..<12).contains(time.hour ?? 0) {
            type = "AM"
        }
        
        // Create alarm and add to UserDefaults
        allAlarms.append(Alarm(time: time, type: type, active: false))
        do {
            let encodeData = try JSONEncoder().encode(allAlarms)
            UserDefaults.standard.set(encodeData, forKey: AlarmKey.alarms.rawValue)
        } catch { print(error) }

        UserDefaults.standard.set(allAlarms.count, forKey: AlarmKey.alarmCount.rawValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Read alarms stored in UserDefaults
    func decodeAlarms() {
        if let alarmData = UserDefaults.standard.object(forKey: AlarmKey.alarms.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let alarms = try? decoder.decode([Alarm].self, from: alarmData) {
                allAlarms = alarms
            }
        }
    }
}
