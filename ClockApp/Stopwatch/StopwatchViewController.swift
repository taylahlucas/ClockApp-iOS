//
//  StopwatchViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 2/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var timer = Timer()
    
    
    // Alarms table
    private let lapsTable: UITableView = {
        let table: UITableView = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.lightGray

        table.register(UITableViewCell.self, forCellReuseIdentifier: "LapCell")
        
        return table
    }()
    
    // Represents time running
    private var timerRunning: Bool {
        return UserDefaults.standard.bool(forKey: StopwatchKey.timerRunning.rawValue)
    }
    
    // Represents start time of the timer
    private var savedTime: Date {
        return UserDefaults.standard.object(forKey: StopwatchKey.savedTime.rawValue) as! Date
    }
    
    // Represents the changing timer displayed
    public var variableTimer: String = "00:00:00"
    private var variableTime: String {
        return UserDefaults.standard.string(forKey: StopwatchKey.variableTime.rawValue) ?? "00:00:00"
    }
    
    // Represents list of laps
    public var laps: [String] = []
    private var savedLaps: [String] {
        return UserDefaults.standard.stringArray(forKey: StopwatchKey.laps.rawValue) ?? []
    }

    // Returns current time
    private var currentTime: Date {
        return Date()
    }
    
    // Represents date formatter
    public let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    // Represents timer displayed
    public lazy var displayTimer: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00:00"
        label.textColor = UIColor.black
        
        return label
    }()

    // Represents the start button
    private lazy var startButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        
        return button
    }()
    
    // Represents the reset button
    private lazy var resetButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(resetOrLapTimer), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lapsTable.dataSource = self
        lapsTable.delegate = self
        
        setupLayout()
        initialTime()
        checkTimer()
        updateUI()
    }
    
    // Removes all objects from UserDefaults
//    private func removeObjects() {
//        let defaults = UserDefaults.standard
//        let dictionary = defaults.dictionaryRepresentation()
//        dictionary.keys.forEach {
//            key in defaults.removeObject(forKey: key)
//        }
//    }

    private func setupLayout() {
        view.backgroundColor = UIColor.white
        
        // Add subviews
        view.addSubview(displayTimer)
        view.addSubview(resetButton)
        view.addSubview(startButton)
        view.addSubview(lapsTable)
        
        // Add constraints
        NSLayoutConstraint.activate([
            displayTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayTimer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
            resetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resetButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            lapsTable.topAnchor.constraint(equalTo: startButton.topAnchor, constant: 100),
            lapsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            lapsTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            lapsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Sets boolean to trigger timer on and off
    @objc func startTimer() {
        if (timerRunning) {             // Stopping timer
            startButton.setTitle(TimerValues.START.rawValue, for: .normal)
            resetButton.setTitle(TimerValues.RESET.rawValue, for: .normal)
            UserDefaults.standard.set(false, forKey: StopwatchKey.timerRunning.rawValue)
            UserDefaults.standard.set(variableTimer, forKey: StopwatchKey.variableTime.rawValue)
            timer.invalidate()
        } else {                        // Starting timer
            startButton.setTitle(TimerValues.STOP.rawValue, for: .normal)
            resetButton.setTitle(TimerValues.LAP.rawValue, for: .normal)
            UserDefaults.standard.set(true, forKey: StopwatchKey.timerRunning.rawValue)
            UserDefaults.standard.set(Date(), forKey: StopwatchKey.savedTime.rawValue)
        }
        
        UserDefaults.standard.set(timerRunning, forKey: StopwatchKey.timerRunning.rawValue)
        checkTimer()
    }
    
    // Resets the timer back to 0 or laps the timer
    @objc func resetOrLapTimer() {
        if (resetButton.titleLabel?.text == TimerValues.RESET.rawValue) {
            variableTimer = "00:00:00"
            laps.removeAll()
            UserDefaults.standard.set(laps, forKey: StopwatchKey.laps.rawValue)
        } else {
            laps.append(variableTimer)
            UserDefaults.standard.set(laps, forKey: StopwatchKey.laps.rawValue)
        }
        updateUI()
        lapsTable.reloadData()
    }
    
    // Check if timer is running
    func checkTimer() {
        if (timerRunning) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(increaseTime), userInfo: timerRunning, repeats: true)
        }
    }
    
    // Starts timer and increases values
    @objc func increaseTime() {
        var date = dateFormatter.date(from: variableTimer)
        date?.addTimeInterval(1)
        variableTimer = dateFormatter.string(from: date ?? Date())
        updateUI()
    }
    
    // Set initial time
    func initialTime() {
        if (timerRunning) {
            let difference = currentTime.timeIntervalSince(savedTime)
            var date = dateFormatter.date(from: variableTimer)
            date?.addTimeInterval(difference)
            variableTimer = dateFormatter.string(from: date ?? Date())
            
            startButton.setTitle(TimerValues.STOP.rawValue, for: .normal)
            resetButton.setTitle(TimerValues.LAP.rawValue, for: .normal)
        } else {
            variableTimer = variableTime
            
            startButton.setTitle(TimerValues.START.rawValue, for: .normal)
            resetButton.setTitle(TimerValues.RESET.rawValue, for: .normal)
        }
        laps = savedLaps
    }

    // Update UI labels to reflect changes in timer
    func updateUI() {
        displayTimer.text = variableTimer
    }

    /* LAP TABLE */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LapCell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = savedLaps[indexPath.row]
        
        return cell
    }
}
