//
//  AddAlarmViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 24/9/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

class AddAlarmViewController: UIViewController {

    // Navigation bar -- make this a seperate controller ???
    private let navBar: UINavigationBar = {
        let nav: UINavigationBar = UINavigationBar()
        nav.translatesAutoresizingMaskIntoConstraints = false
        nav.backgroundColor = UIColor.red
        
        return nav
    }()
    
    // Button to add alarm
    private lazy var addAlarmButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(addAlarm), for: .touchUpInside)
        
        return button
    }()
    
    @objc func addAlarm() {
        print("adding alarm")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(navBar)
        navBar.addSubview(addAlarmButton)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            navBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            addAlarmButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            addAlarmButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            addAlarmButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
            addAlarmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
}
