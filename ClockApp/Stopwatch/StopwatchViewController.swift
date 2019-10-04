//
//  StopwatchViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 2/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

// TO DO -- KEEP UPDATING TIMER EVEN IF APPLICATION IS CLOSED

import UIKit

class StopwatchViewController: UIViewController {
    
    public var timerArray = [UILabel]()         // Stores stack view
    public var initialTimer: Stopwatch = Stopwatch(hour: "00", min: "00", sec: "00")    // Stores value in UserDefaults so it can be accessed again
    public var currentTimer: VariableStopwatch =  VariableStopwatch(hour: 00, min: 00, sec: 00)   // Stores values inbetween starting/stopping timer
    
    public var timerRunning: Bool = false           // Indicates whether timer is running
    public var timer = Timer()
    
    public var savedTimestamp = String()
    public var currentTimestamp = String()
    

    // Represents hour of timer
    private lazy var hourLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(currentTimer.hour)
        label.textColor = UIColor.black
        
        return label
    }()
    
    // Represents minute of timer
    private lazy var minLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(currentTimer.min)
        label.textColor = UIColor.black
        
        return label
    }()
    
    // Represents second of timer
    private lazy var secLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(currentTimer.sec)
        label.textColor = UIColor.black
        
        return label
    }()
    
    // Represents colon to seperate labels
    private lazy var colonLabel1: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  :"
        
        return label
    }()
    
    // Represents colon to seperate labels
    private lazy var colonLabel2: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  :"
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTimerActive()
        getCurrentTimer()
        checkTimer()
        updateUI()
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor.white
        
        // Set up stack view
        let timer = createTimerArray()
        let stackView = UIStackView(arrangedSubviews: timer)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        view.addSubview(stackView)
        view.addSubview(startButton)
        
        // Add constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100)
        ])
    }

    // Create timer array for stack view
    func createTimerArray() -> [UILabel] {
        timerArray = [hourLabel, colonLabel1, minLabel, colonLabel2, secLabel]
        return timerArray
    }
    
    // Get bool indicating if timer is active
    func getTimerActive() {
        if ((UserDefaults.standard.object(forKey: "timerRunning")) != nil) {
            let isTimerRunning = UserDefaults.standard.bool(forKey: "timerRunning")
            timerRunning = isTimerRunning
        } else {            // Add timerActive to UserDefaults
            UserDefaults.standard.set(timerRunning, forKey: "timerRunning")
        }
    }
    
    // Get the current timetamp
    func getTimestamp() {
        let date = NSDate()
        let calendar = Calendar.current
        
        let hour = calendar.component(Calendar.Component.hour, from: date as Date)
        let minute = calendar.component(Calendar.Component.minute, from: date as Date)
        let second = calendar.component(Calendar.Component.second, from: date as Date)

        currentTimestamp = String(hour) + ":" + String(minute) + ":" + String(second)
    }

    // Get current timer from UserDefaults or assign initial value
    func getCurrentTimer() {
        if ((UserDefaults.standard.object(forKey: StopwatchKey.timer.rawValue)) != nil) {
            if let timerData = UserDefaults.standard.object(forKey: StopwatchKey.timer.rawValue) as? Data {
                let decoder = JSONDecoder()
                if let currTimer = try? decoder.decode(Stopwatch.self, from: timerData) {
                    
                    initialTimer = currTimer
                    currentTimer.hour = Int(currTimer.hour) ?? 00
                    currentTimer.min = Int(currTimer.min) ?? 00
                    currentTimer.sec = Int(currTimer.sec) ?? 00
                    
                    updateTime()
                }
            }
        } else {            // If timer does not yet exist in UserDefaults, set initial
            do {
                let encodeData = try JSONEncoder().encode(initialTimer)
                UserDefaults.standard.set(encodeData, forKey: StopwatchKey.timer.rawValue)
            } catch { print(error) }
        }

    }

    // Sets boolean to trigger timer on and off
    @objc func startTimer() {
        if (timerRunning) {             // Stopping timer
            timerRunning = false
            updateTime()
            timer.invalidate()
        } else {                        // Starting timer
            timerRunning = true
            getTimestamp()              // Get and set the timestamp for when the start button is tapped
            UserDefaults.standard.set(currentTimestamp, forKey: "timestamp")
        }
        UserDefaults.standard.set(timerRunning, forKey: "timerRunning")
        checkTimer()
    }
    
    // Check if timer is set to true and increase time
    func checkTimer() {
        if (timerRunning) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(increaseTime), userInfo: timerRunning, repeats: true)

            // Get timestamp
            if (UserDefaults.standard.string(forKey: "timestamp") != nil) {
                savedTimestamp = UserDefaults.standard.string(forKey: "timestamp") ?? "00:00:00"
                getTimestamp()                      // Gets the current timer
                recalculateTimer()
            }
        }
    }
    
    func recalculateTimer() {
        let currTime = currentTimestamp.components(separatedBy: ":").compactMap {
            val in Int(val)
        }
        let savedTime = savedTimestamp.components(separatedBy: ":").compactMap {
            val in Int(val)
        }
        
        print("curr: ", currTime, " saved: ", savedTime)
        
        var hour: Int = 0
        var min: Int = 0
        var sec: Int = 0
        
        hour = currTime[0] - savedTime[0]
        
        if (currTime[1] > savedTime[1]) {
            min = currTime[1] - savedTime[1]
        } else {
            min = 60 - savedTime[1] + currTime[1]
        }
        
        if (currTime[2] > currTime[2]) {
            sec = currTime[2] - savedTime[2]
        } else {
            sec = 60 - savedTime[2] + currTime[2]
        }
        
        print("hour: ", hour, " min: ", min, " sec: ", sec)
        
        let newTime: [Int] = [currTime[0] - savedTime[0], currTime[1] - savedTime[1], currTime[2] - savedTime[2]]
        
        print(newTime)
    }
    
    // Starts timer and increases values
    @objc func increaseTime() {
        if (currentTimer.sec < 60) {                    // Increase seconds
            currentTimer.sec += 1
        }
        if (currentTimer.sec == 60) {                // Increase minutes
            currentTimer.min += 1
            currentTimer.sec = 0
        }
        if (currentTimer.min == 60) {                   // Increase hours
            currentTimer.hour += 1
            currentTimer.min = 0
        }
        updateUI()
    }

    // Update timer in user defaults when timer is paused
    func updateTime() {
        let updatedTimer = Stopwatch(hour: String(currentTimer.hour), min: String(currentTimer.min), sec: String(currentTimer.sec))
        if ((UserDefaults.standard.object(forKey: StopwatchKey.timer.rawValue)) != nil) {
            do {
                let encodeData = try JSONEncoder().encode(updatedTimer)
                UserDefaults.standard.set(encodeData, forKey: StopwatchKey.timer.rawValue)
            } catch { print(error) }
        }
    }
    
    // Update UI labels to reflect changes in timer
    func updateUI() {
        secLabel.text = String(currentTimer.sec)
        minLabel.text = String(currentTimer.min)
        hourLabel.text = String(currentTimer.hour)
    }
}
