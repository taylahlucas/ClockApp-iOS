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

//enum AlarmTime: String, CaseIterable {
//    case alarm
//}

class AddAlarmViewController: UIViewController {
    
    public var alarms: [Alarm] = []

    // View for entire page
    private let contentView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white

        return view
    }()
    
    // Back button
    private let backButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backToPreviousPage), for: .touchUpInside)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    @objc func backToPreviousPage() {
        print("back pressed")
        //self.present(TestViewController, animated: true, completion: nil)
    }
    
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
    
    // Button to check alarms
    private lazy var showAlarmsButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Alarms", for: .normal)
        button.addTarget(self, action: #selector(showAlarms), for: .touchUpInside)
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
        }
    }
    
    // Remove all alarms
    @objc func removeAlarms() {
        alarms.removeAll()
        UserDefaults.standard.set(alarms, forKey: "alarms")
    }
    
    // Show alarm objects
    @objc func showAlarms() {
//        for alarm in alarms {
//            print(alarm)
//        }
//        for key in AlarmTime.allCases {
//            print(UserDefaults.standard.string(forKey: key.rawValue))
//        }
//
        for element in UserDefaults.standard.dictionaryRepresentation() {
            print(element)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(timePicker)
        contentView.addSubview(addAlarmButton)
        contentView.addSubview(removeAlarmsButton)
        contentView.addSubview(showAlarmsButton)
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        // Whole page
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
       // Back button
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30)
        ])


        // Time picker
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            timePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            timePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            timePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -500)
        ])


        // Add alarm button
        NSLayoutConstraint.activate([
            addAlarmButton.topAnchor.constraint(equalTo: timePicker.topAnchor, constant: 200),
            addAlarmButton.leftAnchor.constraint(equalTo: timePicker.leftAnchor, constant: 0),
            addAlarmButton.rightAnchor.constraint(equalTo: timePicker.rightAnchor, constant: 0),
            addAlarmButton.bottomAnchor.constraint(greaterThanOrEqualTo: timePicker.bottomAnchor, constant: 0)
        ])

        // Remove alarm button
        NSLayoutConstraint.activate([
            removeAlarmsButton.topAnchor.constraint(equalTo: timePicker.topAnchor, constant: 300),
            removeAlarmsButton.leftAnchor.constraint(equalTo: timePicker.leftAnchor, constant: 0),
            removeAlarmsButton.rightAnchor.constraint(equalTo: timePicker.rightAnchor, constant: 0),
            removeAlarmsButton.bottomAnchor.constraint(greaterThanOrEqualTo: timePicker.bottomAnchor, constant: 0)
        ])

        // Show alarm button
        NSLayoutConstraint.activate([
            showAlarmsButton.topAnchor.constraint(equalTo: timePicker.topAnchor, constant: 400),
            showAlarmsButton.leftAnchor.constraint(equalTo: timePicker.leftAnchor, constant: 0),
            showAlarmsButton.rightAnchor.constraint(equalTo: timePicker.rightAnchor, constant: 0),
            showAlarmsButton.bottomAnchor.constraint(greaterThanOrEqualTo: timePicker.bottomAnchor, constant: 0)
        ])
    }
}
