//
//  ShowAlarmsViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 1/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

class ShowAlarmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var allAlarms: [Alarm] = []
    public var timer = Timer()
    let manager: LocalNotificationManager = LocalNotificationManager()
    public var editAlarms: Bool = false

    // Number of alarms stored in user defaults
    private var alarmCount: Int {
        return UserDefaults.standard.integer(forKey: AlarmKey.alarmCount.rawValue)
    }
    
    // Indicates whether the timer is running or not
    public var timerRunning: Bool {
       return UserDefaults.standard.bool(forKey: "timerRunning")
    }

    // Alarms table
    private let alarmsTable: UITableView = {
        let table: UITableView = UITableView()
        UIScheme.instance.setTableScheme(for: table)
        table.register(AlarmTableViewCell.self, forCellReuseIdentifier: "AlarmCell")
        return table
    }()
    
    // Add alarms button
    private let addAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addAlarm(_:)), for: .touchUpInside)

        UIScheme.instance.setButtonScheme(for: button)
    
        return button
    }()
    
    // Edit alarms button
    private let editAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(editAlarm(_:)), for: .touchUpInside)
        
        UIScheme.instance.setButtonScheme(for: button)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmsTable.dataSource = self
        alarmsTable.delegate = self
        alarmsTable.allowsSelection = false

        self.view.addSubview(editAlarmButton)
        self.view.addSubview(addAlarmButton)
        self.view.addSubview(alarmsTable)
        
       // removeObjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupLayout()
        decodeAlarms()
        scheduleNotifications()
    }

    func removeObjects() {
        
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    func setupLayout() {
        UIScheme.instance.setViewScheme(for: self)
        UIColorScheme.instance.setUnselectedButtonScheme(for: addAlarmButton)
        
        NSLayoutConstraint.activate([
            editAlarmButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            editAlarmButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            addAlarmButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            addAlarmButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            alarmsTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            alarmsTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            alarmsTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            alarmsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    // Present add alarm page
    @objc func addAlarm(_ sender: UIButton) {
        UIColorScheme.instance.setSelectedButtonScheme(for: sender)
        self.navigationController?.pushViewController(AddAlarmViewController(), animated: true)
    }

    // Display remove button on all alarms in table
    @objc func editAlarm(_ sender: UIButton) {
        alarmsTable.setEditing(!alarmsTable.isEditing, animated: true)
        if (alarmsTable.isEditing == true) {
            UIColorScheme.instance.setSelectedButtonScheme(for: sender)
            editAlarmButton.setTitle("Done", for: .normal)
        } else {
            UIColorScheme.instance.setUnselectedButtonScheme(for: sender)
            editAlarmButton.setTitle("Edit", for: .normal)
        }
    }
    
    // Encode alarms array to be stored in UserDefaults
    func encodeData() {
        do {
            let encodeData = try JSONEncoder().encode(allAlarms)
            UserDefaults.standard.set(encodeData, forKey: AlarmKey.alarms.rawValue)
        } catch { print(error) }
    }
    
    // Read alarms stored in UserDefaults
    func decodeAlarms() {
        if let alarmData = UserDefaults.standard.object(forKey: AlarmKey.alarms.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let alarms = try? decoder.decode([Alarm].self, from: alarmData) {
                allAlarms = alarms
                alarmsTable.reloadData()
            }
        }
    }

    // Schedule notifications to occur based on switches
    func scheduleNotifications() {
        var notifications: [Notification] = [Notification]()
        for (index, alarm) in allAlarms.enumerated() {
            if alarm.active {
                notifications.append(Notification(id: String(index), title: "Alarm", dateTime: alarm.time))
            }
            manager.notifications = notifications
            manager.schedule()
        }
        manager.notifications = notifications
        manager.schedule()
    }

    // Activate or deactivate alarm
    @objc func activateAlarm(_ sender: UISwitch!) {
        let point = alarmsTable.convert(sender.center, from: sender.superview)
        let indexPath = alarmsTable.indexPathForRow(at: point)
        
        allAlarms[indexPath?.row ?? 0].active = sender.isOn

        encodeData()
        scheduleNotifications()
    }
    
    /* TABLE FUNCTIONS */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.integer(forKey: AlarmKey.alarmCount.rawValue)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarm = allAlarms[indexPath.row]
        let time = alarm.time

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? AlarmTableViewCell else {
          return UITableViewCell()
        }

        // Convert to 12 hour time for label
        var newHour = time.hour
        if (alarm.type == "PM" && newHour != 12) {
            newHour = (time.hour ?? 0) - 12
        }
        // Add 0 to beginning of minute for all values < 10
        var newMin: String = "\(time.minute ?? 0)"
        if (time.minute ?? 0 < 10) {
            newMin = "0" + "\(time.minute ?? 0)"
        }
        
        cell.timeLabel.text = "\(newHour ?? 0)" + ":" + newMin
        cell.typeLabel.text = alarm.type
        
        UIScheme.instance.setAlarmCellScheme(for: cell)
        
        cell.activateAlarmSwitch.addTarget(self, action: #selector(activateAlarm(_:)), for: .touchUpInside)
        cell.activateAlarmSwitch.isOn = alarm.active

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        allAlarms.remove(at: indexPath.row)
        UserDefaults.standard.set(alarmCount-1, forKey: AlarmKey.alarmCount.rawValue)
        encodeData()
        alarmsTable.reloadData()
    }
}
