//
//  ViewController.swift
//  http_request_response
//
//  Created by James on 3/13/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

// MARK: - Define Mappable JSON Object -

struct TimezoneResponse: Mappable {
    
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
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        week_number    <- map["week_number"]
        utc_offset     <- map["utc_offset"]
        utc_datetime   <- map["utc_datetime"]
        unixtime       <- map["unixtime"]
        timezone       <- map["timezone"]
        raw_offset     <- map["raw_offset"]
        dst_until      <- map["dst_until"]
        dst_offset     <- map["dst_offset"]
        dst_from       <- map["dst_from"]
        dst            <- map["dst"]
        day_of_year    <- map["day_of_year"]
        datetime       <- map["datetime"]
        client_ip      <- map["client_ip"]
        abbreviation   <- map["abbreviation"]
        error          <- map["error"]
    }
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
        
        /// form request with parameters
        var requestParameters = [String : Any]()
        
        let timeRequest = Alamofire.request(urlList[urlIndex], method: .get, parameters: nil)
        
        timeRequest.responseJSON { response in
                        
            // capture json format from response
            guard let json = response.value as? [String : Any] else {
                self.outputLabel.text! += "\nerror: capturing json in response"
                return
            }
            
            // map json to response type
            guard let response = Mapper<TimezoneResponse>().map(JSON: json) else {
                self.outputLabel.text! += "\nerror: mapping timezone response failure"
                return
            }
            
            // check for error (ie: "unknown location") else print some information
            if let responseError = response.error {
                
                self.outputLabel.text! += responseError
                
            } else {
            
                self.outputLabel.text! += "\nclient ip: " + (response.client_ip ?? "unknown")
                self.outputLabel.text! += "\ntimezone: " + (response.timezone ?? "unknown")
                self.outputLabel.text! += "\ndatetime: " + (response.datetime ?? "unknown")
                self.outputLabel.text! += "\nabbreviation: " + (response.abbreviation ?? "unknown")
            }
            
//            self.outputLabel.sizeToFit()
        }
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        outputLabel.text = ""
    }
}

