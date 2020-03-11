//
//  EndpointCheck.swift
//  endpoint_ping
//
//  Created by James on 3/10/20.
//  Copyright © 2020 James. All rights reserved.
//

import Foundation
import PlainPing

// MARK: - Closure Definitions -

typealias ClosureWithError = (_ error: String) -> Void
typealias ClosureWithString = (_ string: String) -> Void

// MARK: - EndpointCheck -

final class EndpointCheck {
    
    // MARK: - Public Static Members -

    static let sharedEndpointCheck = EndpointCheck()
    
    // MARK: - Public Methods -
        
    /// Wrapper to call ping method and write output
    ///
    /// - parameter host: received as host name and http/s port which will be stripped
    /// - parameter count: number of ping attempts
    /// - parameter interval: duration in seconds between ping attempts
    /// - parameter timeout: duration in seconds to quit
    ///
    func networkPing(host: String, count: Int, interval: Double, timeout: Double, endpointDescription: String = "endpoint", success: @escaping ClosureWithString, failure: @escaping ClosureWithError) {

        let hostNoPort     = host.components(separatedBy: ":")[0]  // strip away port number

        let counter        = (count > 0)    ? count   : 1          // enforce one or more ping iterations
        let timeOut        = (counter == 1) ? timeout : 3.0        // default if pinging more than once
        let pauseInterval  = (count == 1)   ? 0.0     : interval   // pause only if there are more than one iteration
        var iteration: Int = 0                                     // ping iteration
        var resultString   = ""                                    // this can be captured in calling closure
        var failureString  = ""                                    // captured in failure closure

        func doNetworkPing(_ host: String) {

            PlainPing.ping(host, withTimeout: timeout, completionBlock: { (timeElapsed: Double?, error: Error?) in

                if let latency = timeElapsed {
                    print("\(endpointDescription) - \(host) - time = \(round(1000*latency)/1000) ms")
                    resultString += "\(endpointDescription) - \(host) - time = \(round(1000*latency)/1000) ms \n"

                    success(resultString)
                }

                if let error = error {
                    print("error: \(error) -- localized description: \(error.localizedDescription)")
                    failureString += "\(endpointDescription) - \(host) - error: \(error.localizedDescription)"
                    
                    failure(failureString)
                }

                iteration += 1

                if iteration < counter {
                    doNetworkPing(host)
                }
            })
        }

        doNetworkPing(hostNoPort)
    }
}
