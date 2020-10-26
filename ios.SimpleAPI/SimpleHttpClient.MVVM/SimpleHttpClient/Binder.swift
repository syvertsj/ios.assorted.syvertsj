//
//  Binder.swift
//  SimpleHttpClient
//
//  Created by James on 10/25/20.
//

import Foundation

// example of the decorator pattern

final class Binder<T> {
    
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    // observed property
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
