//
//  Message.swift
//  SimpleHttpClient
//
//  Created by James on 10/25/20.
//

import Foundation

// MARK: - GET message
struct Message: Codable {
    var id: Int
    var message: String
}
