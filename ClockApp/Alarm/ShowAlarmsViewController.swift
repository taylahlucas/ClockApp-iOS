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
   // public var alarmCount: Int =
    // Number of alarms stored in user defaults
//    private let alarmCount: Int = {
//        return UserDefaults.standard.integer(forKey: AlarmKey.alarmCount.rawValue)
//    }()
    
    // Alarms table
    private let alarmsTable: UITableView = {
        let table: UITableView = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.lightGray

        table.register(AlarmTableViewCell.self, forCellReuseIdentifier: "AlarmCell")
        return table
    }()
    
    // Add alarms button
    private let addAlarmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addAlarm), for: .touchUpInside)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    // Edit alarms button
    private let editAlarmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(editAlarm), for: .touchUpInside)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()
    
    // Remove alarm button image
    private let removeAlarmImage: UIView = {
        let view = UIView()
        let button = UIButton()
        
        button.setImage(UIImage(named: "remove"), for: .normal)
        view.addSubview(button)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        alarmsTable.dataSource = self
        alarmsTable.delegate = self
        alarmsTable.allowsSelection = false
        
        self.view.addSubview(editAlarmButton)
        self.view.addSubview(addAlarmButton)
        self.view.addSubview(alarmsTable)

        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readAlarms()
        scheduleNotifications()
    }

    func setupLayout() {
        view.backgroundColor = UIColor.white
        
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
    @objc func addAlarm() {
        self.navigationController?.pushViewController(AddAlarmViewController(), animated: true)
    }

    // Display remove button on all alarms in table
    @objc func editAlarm() {
        if (editAlarms) {
            editAlarms = false
        } else {
            editAlarms = true
        }
        alarmsTable.reloadData()
    }
    
    // Remove an individual alarm
    @objc func removeAlarm(_ sender: UIButton) {
        let point = alarmsTable.convert(sender.center, from: sender.superview)
        let indexPath = alarmsTable.indexPathForRow(at: point)
        
        print(allAlarms)
        allAlarms.remove(at: indexPath?.row ?? 0)

        print("alarmCount: ", alarmCount)
        UserDefaults.standard.set(alarmCount-1, forKey: AlarmKey.alarmCount.rawValue)
        alarmsTable.reloadData()
    }
    
    // Read alarms stored in UserDefaults
    func readAlarms() {
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
        var i = 0
        for alarm in allAlarms {
            if (alarm.active) {
                notifications.append(Notification(id: String(i), title: "Alarm", dateTime: alarm.time))
            }
            i += 1
        }
        manager.notifications = notifications
        manager.schedule()
    }

    // Activate or deactivate alarm
    @objc func activateAlarm(_ sender: UISwitch!) {
        let point = alarmsTable.convert(sender.center, from: sender.superview)
        let indexPath = alarmsTable.indexPathForRow(at: point)
        
        if (sender.isOn) {
            allAlarms[indexPath?.row ?? 0].active = true
        } else {
            allAlarms[indexPath?.row ?? 0].active = false
        }

        do {
            let encodeData = try JSONEncoder().encode(allAlarms)
            UserDefaults.standard.set(encodeData, forKey: AlarmKey.alarms.rawValue)
        } catch { print(error) }
        
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
        
        // Adds image to remove alarm
        if (editAlarms) {
            cell.removeAlarmButton.setImage(UIImage(named: "remove"), for: .normal)
            cell.removeAlarmButton.addTarget(self, action: #selector(removeAlarm), for: .touchUpInside)
        } else {
            cell.removeAlarmButton.setImage(nil, for: .normal)
        }
        
        cell.textLabel?.text =  "\(newHour ?? 0)" + ":" + newMin + alarm.type
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = UIColor.white
        cell.activateAlarmSwitch.addTarget(self, action: #selector(activateAlarm(_:)), for: .touchUpInside)
      
        // Set initial switch value
        if (alarm.active == true) {
            cell.activateAlarmSwitch.isOn = true
        } else {
            cell.activateAlarmSwitch.isOn = false
        }

        return cell
    }
}
