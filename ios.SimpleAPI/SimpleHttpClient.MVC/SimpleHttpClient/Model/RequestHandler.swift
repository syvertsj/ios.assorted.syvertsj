//
//  RequestHandler.swift
//  SimpleHttpClient
//
//  Created by James on 10/25/20.
//

import Foundation

// MARK: - Http Request class
class RequestHandler {
    
    // MARK: - singleton option
    static let shared: RequestHandler = RequestHandler()
    
    var delegate: ApiResponseDelegate? = nil
    
    var responseString = ""
        
    // MARK: - GET request
    func getRequest() {
        
        guard let url = URL(string: "http://localhost:9999/api/v1/data") else { return }
        
        urlSession(url: URLRequest(url: url))
    }
    
    // MARK: - POST request
    func postRequest() { // -> String {
     
        guard let url = URL(string: "http://localhost:9999/post/a_url_message") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        urlSession(url: urlRequest)
    }
    
    // MARK: - URLSession helper method
    func urlSession(url: URLRequest) {
                
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            guard error == nil else {
                // this will print a transport security error if trying to connect to server that is not using SSL
                // workaround is to set "Allow Transport Security Settings" key in Info.plist
                print("\n error: \(error!.localizedDescription)")
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
                let json = try JSONDecoder().decode(Response.self, from: data!)

                print(json)

                // note: this can only work for both get and post requests here because the
                // json message format is the same
                DispatchQueue.main.async {
                    self.responseString = json.message
                    self.delegate?.getResponse()
                }

            } catch {
                self.responseString = "JSON serialization error: \(error.localizedDescription)"
            }
        })
        
        // execuate task
        task.resume()
    }
}
