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
    
    // Represents the changing timer displayed
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
        
//     removeObjects()

        setupLayout()
        initialTime()
        checkTimer()
        updateUI()
    }
    
    // Removes all objects from UserDefaults
    private func removeObjects() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach {
            key in defaults.removeObject(forKey: key)
        }
    }

    private func setupLayout() {
        view.backgroundColor = UIColor.white
        
        // Add subviews
        view.addSubview(displayTimer)
        view.addSubview(resetButton)
        view.addSubview(startButton)
        
        // Add constraints
        NSLayoutConstraint.activate([
            displayTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayTimer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
            resetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resetButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100)
        ])
    }

    // Sets boolean to trigger timer on and off
    @objc func startTimer() {
        if (timerRunning) {             // Stopping timer
            startButton.setTitle("START", for: .normal)
            UserDefaults.standard.set(false, forKey: "timerRunning")
            UserDefaults.standard.set(variableTimer, forKey: "variableTime")
            timer.invalidate()
        } else {                        // Starting timer
            startButton.setTitle("STOP", for: .normal)
            UserDefaults.standard.set(true, forKey: "timerRunning")
            UserDefaults.standard.set(Date(), forKey: "savedTime")
        }
        
        UserDefaults.standard.set(timerRunning, forKey: "timerRunning")
        checkTimer()
    }
    
    // Resets the timer back to 0
    @objc func resetTimer() {
        variableTimer = "00:00:00"
        updateUI()
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
        variableTimer = dateFormatter.string(from: date!)
        updateUI()
    }
    
    // Set initial time
    func initialTime() {
        if (timerRunning) {
            let difference = currentTime.timeIntervalSince(savedTime)
            var date = dateFormatter.date(from: variableTimer)
            date?.addTimeInterval(difference)
            variableTimer = dateFormatter.string(from: date!)
        } else {
            variableTimer = variableTime
        }
    }

    // Update UI labels to reflect changes in timer
    func updateUI() {
        displayTimer.text = variableTimer
    }
}
