//
//  ViewController.swift
//  SimpleHttpClient
//
//  Created by James on 10/25/20.
//

import UIKit

class ViewController: UIViewController, ApiResponseDelegate {

    @IBOutlet weak var httpResponseLabel: UILabel!

    let requestHandler = RequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestHandler.delegate = self
    }

    @IBAction func getButtonPressed(_ sender: UIButton) {
    
        requestHandler.getRequest()
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
    
        requestHandler.postRequest()
    }
    
    // MARK: - ApiResponseDelegate methods
    func getResponse() {
        
        httpResponseLabel.text = requestHandler.responseString
    }
}

