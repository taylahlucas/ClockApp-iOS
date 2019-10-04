//
//  StopwatchViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 2/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {

    public var timer = Timer()
    
    // Represents time running
    private var timerRunning: Bool {
        return UserDefaults.standard.bool(forKey: "timerRunning")
    }
    
    // Represents start time of the timer
    private var savedTime: Date {
        return UserDefaults.standard.object(forKey: "savedTime") as! Date
    }
    
    public var variableTimer: String = "00:00:00"
    private var variableTime: String {
        return UserDefaults.standard.string(forKey: "variableTime") ?? "00:00:00"
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
        button.setTitle("START", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        
        return button
    }()
    
    // Represents the reset button
    private lazy var resetButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        removeObjects()

        setupLayout()
        checkTimer()
        updateUI()

//        printObjects()
    }
    
    // Removes all objects from UserDefaults
    private func removeObjects() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach {
            key in defaults.removeObject(forKey: key)
        }
    }
    
    // Print all objects from UserDefaults
    private func printObjects() {
        print(Array(UserDefaults.standard.dictionaryRepresentation()))
    }

    private func setupLayout() {
        view.backgroundColor = UIColor.white
        
        // Add subviews
        view.addSubview(displayTimer)
        view.addSubview(startButton)
        view.addSubview(resetButton)
        
        // Add constraints
        NSLayoutConstraint.activate([
            displayTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayTimer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100)
        ])
    }

    // Sets boolean to trigger timer on and off
    @objc func startTimer() {
        if (timerRunning) {             // Stopping timer
            UserDefaults.standard.set(false, forKey: "timerRunning")
            UserDefaults.standard.set(variableTimer, forKey: "variableTime")
            timer.invalidate()
        } else {                        // Starting timer
            UserDefaults.standard.set(true, forKey: "timerRunning")
            // Store current date to compare
            UserDefaults.standard.set(Date(), forKey: "savedTime")
        }
        
        UserDefaults.standard.set(timerRunning, forKey: "timerRunning")
        checkTimer()
    }
    
    @objc func resetTimer() {
       // let test = dateFormatter.date(from: "00:00:00")
        //variableTimer = test ?? <#default value#>
        //UserDefaults.standard.set("00:00:00", forKey: "savedTimer")
        
    }
    
    // Time difference between savedTime and currentTime
    func timeBetween() {
        let difference = currentTime.timeIntervalSince(savedTime)/100
        
        increaseTime(interval: difference)
    }
    
    // Check if timer is running
    func checkTimer() {
        if (timerRunning) {
            print("savedTime: ", savedTime, " currentTime: ", currentTime)
            timeBetween()
        
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(increaseTime), userInfo: timerRunning, repeats: true)
        }
    }
    
    // Starts timer and increases values
    @objc func increaseTime(interval: TimeInterval) {
        var date = dateFormatter.date(from: variableTimer)
        date?.addTimeInterval(interval)
        variableTimer = dateFormatter.string(from: date!)
        updateUI()
    }

    // Update UI labels to reflect changes in timer
    func updateUI() {
        displayTimer.text = variableTimer
    }
}
