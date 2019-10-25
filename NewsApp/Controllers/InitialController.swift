//
//  InitialController.swift
//  NewsApp
//
//  Created by Cosme Fulanito on 25/10/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit

class InitialController: UIViewController {
    
    override func viewDidLoad() {
        view = UIView()
        view.backgroundColor = .yellow
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello there"
        label.textColor = .blue
        
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
