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
    
    // Alarms table
    private let alarmsTable: UITableView = {
        let table: UITableView = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.lightGray

        table.register(AlarmTableViewCell.self, forCellReuseIdentifier: "AlarmCell")
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        alarmsTable.dataSource = self
        alarmsTable.delegate = self
        self.view.addSubview(alarmsTable)
        
        
        setupLayout()
        readAlarms()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([alarmsTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                                    alarmsTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
                                    alarmsTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
                                    alarmsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)])
    }
    
    // Read alarms stored in UserDefaults
    func readAlarms() {
        if let alarmData = UserDefaults.standard.object(forKey: "alarms") as? Data {
            let decoder = JSONDecoder()
            if let alarms = try? decoder.decode([Alarm].self, from: alarmData) {
                allAlarms = alarms
            }
        }
    }
    
    
    /* TABLE FUNCTIONS */
    // Number of rows in section -- number of alarms
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.integer(forKey: "alarmCount")
    }
    
    // Return contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let alarm = allAlarms[indexPath.row]
        let title = String(alarm.hour) + ":" + String(alarm.minute) + " " + alarm.type

        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmTableViewCell

//        cell.textLabel?.text = title
         
        let showAlarm = AlarmCell(timeLabel: title, activate: false)
        cell.updateCell(with: showAlarm)
        
        // not showing on table ???
        print("here: ", cell.alarm?.timeLabel)
        
    
        return cell
    }
    
}
