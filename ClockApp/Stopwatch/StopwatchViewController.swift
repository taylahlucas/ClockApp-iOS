//
//  StopwatchViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 2/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {
    
    public var timerArray = [UILabel]()
    public var initialTimer: Stopwatch = Stopwatch(hour: "00 :", min: "00 :", sec: "00")
    public var timerRunning: Bool = false

    // Represents hour of timer
    private lazy var hourLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = initialTimer.hour
        
        return label
    }()
    
    // Represents minute of timer
    private lazy var minLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = initialTimer.min
        
        return label
    }()
    
    // Represents second of timer
    private lazy var secLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = initialTimer.sec
        
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
        
        setInitialTimer()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentTimer()
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor.white
        
        // Set up stack view
        let timer = createTimerArray()
        let stackView = UIStackView(arrangedSubviews: timer)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
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
    
    // Sets boolean to trigger timer on and off
    @objc func startTimer() {
        if (timerRunning) {
            timerRunning = false
        } else {
            timerRunning = true
        }
        increaseTime(timerRunning: timerRunning)
    }
    
    func increaseTime(timerRunning: Bool) {
        // Create copy of timer to modify
        var sec: Int = Int(initialTimer.sec) ?? 0
        var min: Int = Int(initialTimer.min) ?? 0
        var hour: Int = Int(initialTimer.hour) ?? 0
        
        if (timerRunning) {
            // Increase seconds
            if (sec < 60) {
                sec += 1
            }
            // Increase minutes
            if (sec == 60) {
                min += 1
                sec = 0
            }
            // Increase hours
            if (min == 60) {
                hour += 1
                min = 0
            }
           // updateTime(sec, min, hour)
        }
        
        
    }
    
    // Set initial timer
    func setInitialTimer() {
        if ((UserDefaults.standard.object(forKey: StopwatchKey.timer.rawValue)) == nil) {
            do {
                let encodeData = try JSONEncoder().encode(initialTimer)
                UserDefaults.standard.set(encodeData, forKey: StopwatchKey.timer.rawValue)
            } catch { print(error) }
        }
    }
    
    // Create timer array for stack view
    func createTimerArray() -> [UILabel] {
        timerArray = [hourLabel, minLabel, secLabel]
        
        return timerArray
    }
    
    func getCurrentTimer() {
    // Get current timer
        if let timerData = UserDefaults.standard.object(forKey: StopwatchKey.timer.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let currentTimer = try? decoder.decode(Stopwatch.self, from: timerData) {
                initialTimer = currentTimer
            }
        }
    }
    
    func updateTime() {
        
    }
}
