//
//  ViewController.swift
//  http_urlsession
//
//  Created by James on 3/14/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Define Codable JSON Object -

struct TimezoneResponse: Codable {
    
    // copied from curl response in terminal:
    // curl "https://worldtimeapi.org/api/timezone/America/New_York"
    /* {"week_number":11,"utc_offset":"-04:00","utc_datetime":"2020-03-14T03:18:01.894480+00:00","unixtime":1584155881,"timezone":"America/New_York","raw_offset":-18000,"dst_until":"2020-11-01T06:00:00+00:00","dst_offset":3600,"dst_from":"2020-03-08T07:00:00+00:00","dst":true,"day_of_year":73,"day_of_week":5,"datetime":"2020-03-13T23:18:01.894480-04:00","client_ip":"69.112.240.58","abbreviation":"EDT"}
     */
    // curl "https://worldtimeapi.org/api/timezone/America/Wrong_New_York"
    /*
     {"error":"unknown location"}
     */
    
    var week_number: Int?
    var utc_offset: String?
    var utc_datetime: String?
    var unixtime: Int?
    var timezone: String?
    var raw_offset: Int?
    var dst_until: String?
    var dst_offset: Int?
    var dst_from: String?
    var dst: Bool?
    var day_of_year: Int?
    var datetime: String?
    var client_ip: String?
    var abbreviation: String?
    var error: String?
}

// MARK: - View Controller -

class ViewController: UIViewController {

    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    let urlList: [String] = ["https://worldtimeapi.org/api/timezone/America/New_York",
                             "https://worldtimeapi.org/api/timezone/America/Wrong_New_York"]

    var urlIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        urlLabel.text = urlList.first
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        urlIndex = (urlIndex + 1) % urlList.count
        urlLabel.text = urlList[urlIndex]
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        outputLabel.text = "submitting http request to: " + urlList[urlIndex] + "\n\n"
        
        let session = URLSession.shared
        guard let url = URL(string: urlList[urlIndex]) else { return }
                       
        // note: task gets put on a DispatchQueue to be executed asynchronously (happens after task.resume() called later
        // this requires using the main DispatchQueue for writing to UI components within closure
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            
            guard error == nil else {
                print("\n error: ", error.debugDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                guard httpResponse.statusCode == 200 else {
                    print("\n http error: \(httpResponse.statusCode)")
                    return
                }
            }
            
            // serialize data into json object
            do {
                let json = try JSONDecoder().decode(TimezoneResponse.self, from: data!)
                
                print(json)
                
                DispatchQueue.main.async {
                    self.outputLabel.text! += "\nclient ip: " + (json.client_ip ?? "unknown")
                    self.outputLabel.text! += "\ndatetime: " + (json.datetime ?? "unknown")
                    self.outputLabel.text! += "\nabbreviation: " + (json.abbreviation ?? "unknown")                    
                }
                
            } catch {
                print("\nJSON serialization error: ", error.localizedDescription)
            }
        })
        
        // executes the task
        task.resume()
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        outputLabel.text = ""
    }
}

