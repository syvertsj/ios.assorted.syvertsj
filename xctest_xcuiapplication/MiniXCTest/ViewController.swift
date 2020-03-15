//
//  ViewController.swift
//  MiniXCTest
//
//  Created by James on 3/15/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        label.accessibilityIdentifier = "LabelAccessID"
        label.accessibilityLabel = "LabelAccessLabel"
    }

    @IBAction func buttonPressAction(_ sender: Any) {
        
        guard !textField.text!.isEmpty else {
            button.titleLabel?.text = "Button"
            label.text = "Label"
            return
        }
        
        label.text = "Label" + textField.text!
    }
    
}

