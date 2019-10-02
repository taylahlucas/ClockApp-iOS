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
    public var initialTimer: Stopwatch = Stopwatch(hour: "00", min: "00", sec: "00")    // Stores value in UserDefaults so it can be accessed again
    public var currentTimer: VariableStopwatch =  VariableStopwatch(hour: 00, min: 00, sec: 00)   // Stores values inbetween starting/stopping timer
    
    public var timerRunning: Bool = false           // Indicates whether timer is running
    public var timer = Timer()
    

    // Represents hour of timer
    private lazy var hourLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(currentTimer.hour)
        
        return label
    }()
    
    // Represents minute of timer
    private lazy var minLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(currentTimer.min)
        
        return label
    }()
    
    // Represents second of timer
    private lazy var secLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(currentTimer.sec)
        
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
        getCurrentTimer()
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
    // FIX - Not letting me use colonLabel twice so had to create two seperate variables ??
        timerArray = [hourLabel, colonLabel1, minLabel, colonLabel2, secLabel]
        return timerArray
    }
    
    func getCurrentTimer() {
        // Get current timer from UserDefaults
        if ((UserDefaults.standard.object(forKey: StopwatchKey.timer.rawValue)) != nil) {
            if let timerData = UserDefaults.standard.object(forKey: StopwatchKey.timer.rawValue) as? Data {
                print("getting current timer")
                let decoder = JSONDecoder()
                if let currTimer = try? decoder.decode(Stopwatch.self, from: timerData) {
                    
                    
                    initialTimer = currTimer
                    // Set currentTime to inital Timer or 00
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
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(increaseTime), userInfo: timerRunning, repeats: true)
        }
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
                print("updating timer to: ", updatedTimer)
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
