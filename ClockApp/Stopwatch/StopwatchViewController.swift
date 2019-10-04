//
//  StopwatchViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 2/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {
    
    public var timerArray = [UILabel]()         // Stores stack view
    public var variableTimer: Date = Date()
    public var timer = Timer()
    
    // Represents time running
    private var timerRunning: Bool {
        return UserDefaults.standard.bool(forKey: "timerRunning")
    }

    // Represents start value of timer
    private var savedTimer: String {
        return UserDefaults.standard.string(forKey: StopwatchKey.timer.rawValue) ?? "00:00:00"
    }
    
    // Returns current time
    private var currentTime: Date {
        return Date()
    }
    
    // Represents date formatter
    public let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()

        checkTimer()
        updateUI()
        
        //print(Array(UserDefaults.standard.dictionaryRepresentation()))
    }

    private func setupLayout() {
        view.backgroundColor = UIColor.white
        
        // Add subviews
        view.addSubview(displayTimer)
        view.addSubview(startButton)
        
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
            updateTime()
            timer.invalidate()
        } else {                        // Starting timer
            UserDefaults.standard.set(true, forKey: "timerRunning")
            UserDefaults.standard.set(currentTime, forKey: "timestamp")
            variableTimer = currentTime
        }
        
        UserDefaults.standard.set(timerRunning, forKey: "timerRunning")
        checkTimer()
    }
    
    // Check if timer is running
    func checkTimer() {
        if (timerRunning) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(increaseTime), userInfo: timerRunning, repeats: true)
            
            recalculateTimer()
        }
    }

    // Get time difference between two time stamps and reset timer
    func recalculateTimer() {
        print("savedTime: ", savedTimer)
        print("currentTime: ", currentTime)
        
        print("timer: ", variableTimer)
        
       // let currStamp = dateFormatter.date(from: currentTimestamp)
      //  let currStamp = Date()
        
//        guard let savedStamp = dateFormatter.date(from: savedTimestamp) else
//        {
//            return
//        }
//
//        let timeDifference = currStamp.timeIntervalSince(savedStamp)
//        let addTime = timeDifference/100
//        currentTimer.addTimeInterval(addTime)
        
//        updateTime()
    }
    
    // Starts timer and increases values
    @objc func increaseTime() {
        variableTimer.addTimeInterval(1)
        updateUI()
    }

    // Update timer in user defaults when timer is paused
    func updateTime() {
        print("variable Timer: ", variableTimer)
        do {
            let encodeData = try JSONEncoder().encode(variableTimer)
            UserDefaults.standard.set(encodeData, forKey: StopwatchKey.timer.rawValue)
        } catch { print(error) }
    }
    
    // Update UI labels to reflect changes in timer
    func updateUI() {
        displayTimer.text = dateFormatter.string(from: variableTimer)
    }
}
