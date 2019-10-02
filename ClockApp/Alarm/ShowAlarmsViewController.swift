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
        button.setTitle("Add Alarm", for: .normal)
        button.addTarget(self, action: #selector(addAlarm), for: .touchUpInside)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        alarmsTable.dataSource = self
        alarmsTable.delegate = self
        self.view.addSubview(addAlarmButton)
        self.view.addSubview(alarmsTable)
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readAlarms()
        checkTime()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor.white
        
        NSLayoutConstraint.activate([
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
    
    func checkTime() {
        let date = NSDate()
        let calendar = Calendar.current
        
        let hour = calendar.component(Calendar.Component.hour, from: date as Date)
        let minute = calendar.component(Calendar.Component.minute, from: date as Date)
        let second = calendar.component(Calendar.Component.second, from: date as Date)

        compareTime(hour: hour, mins: minute, secs: second)
    }
    
    func compareTime(hour: Int, mins: Int, secs: Int) {
        // Get all alarms that are activated
        readAlarms()
        
    }
    
    /* TABLE FUNCTIONS */
    // Number of rows in section -- number of alarms
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.integer(forKey: AlarmKey.alarmCount.rawValue)
    }
    
    // Return contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarm = allAlarms[indexPath.row]
        let title = String(alarm.hour) + ":" + String(alarm.minute) + " " + alarm.type

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? AlarmTableViewCell else {
            return UITableViewCell()
        }

        let alarmCell = AlarmCell(timeLabel: title, activate: cell.getSwitchValue())
        cell.updateCell(with: alarmCell)

        return cell
    }
    
    // Need to refactor this code so that we know when a value has changed on a cell
    // This will detect when a cell is being clicked on
    // TO DO -- figure out how to detect if switch is on in cell
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
    
}
