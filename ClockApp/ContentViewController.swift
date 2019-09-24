//
//  ContentViewController.swift
//  ClockApp
//
//  Created by Taylah Lucas on 24/9/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    // MARK: - UI
    
    private let contentView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        
        return view
    }()
    
//    // MARK: - Initialization
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add all subviews as required
        view.addSubview(contentView)
        
        // Call layout method
        setupLayout()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        //
        //view.safeAreaInsets
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}
