//
//  ViewController.swift
//  endpoint_ping
//
//  Created by James on 3/10/20.
//  Copyright © 2020 James. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitPingButton: UIButton!
    @IBOutlet weak var outputTextField: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        urlTextField.delegate = self
        urlTextField.placeholder = "URL Endpoint"
        urlTextField.clearButtonMode = UITextField.ViewMode.always
        submitPingButton.isEnabled = false
        clearButton.isEnabled = false
    }
    
    /// ping button action
    @IBAction func buttonPressAction(_ sender: Any) {
        
        outputTextField.text = ""
        
        EndpointCheck.sharedEndpointCheck.networkPing(host: urlTextField.text ?? "", count: 3, interval: 1.0, timeout: 5.0, success: { successString in
            self.outputTextField.text! += successString
        }, failure: { errorString in
            self.outputTextField.text! += errorString
        })
        
        clearButton.isEnabled = true
    }
    
    /// clear button action
    @IBAction func clearButtonAction(_ sender: Any) {
        outputTextField.text = ""
        clearButton.isEnabled = false
    }
}

// MARK: - Extension: UITextFieldDelegate -

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = (textField.text?.isEmpty ?? false) ? string : textField.text, !text.isEmpty else { return true }
        
        submitPingButton.isEnabled = true
        clearButton.isEnabled = !(outputTextField.text?.isEmpty ?? true)
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        submitPingButton.isEnabled = false
        clearButton.isEnabled = !(outputTextField.text?.isEmpty ?? true)
        
        return true
    }
}
