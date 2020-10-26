//
//  ViewController.swift
//  SimpleHttpClient
//
//  Created by James on 10/25/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var httpResponseLabel: UILabel!
    
    private var viewModel = RequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bind view properties to observed properties in the model
        viewModel.responseString.bind { self.httpResponseLabel.text = $0 }
    }

    @IBAction func getButtonPressed(_ sender: UIButton) {
    
        viewModel.getRequest()
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
    
        viewModel.postRequest()
    }
}

