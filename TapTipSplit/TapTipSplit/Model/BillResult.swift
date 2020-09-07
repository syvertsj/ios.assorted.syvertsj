//
//  BillResult.swift
//  TapTipSplit
//
//  Created by James on 9/3/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

struct BillResult {
    var split: String = "1"
    var tip: String = "0"
    var totalPerPerson: String = "0.0"
    var billTotal: String = "0.0"
    
    func billDetailText() -> String {
        return "$\(billTotal) with \(tip)% tip split between \(split)"
    }
}
