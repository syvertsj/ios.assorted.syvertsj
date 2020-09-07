//
//  Bill.swift
//  TapTipSplit
//
//  Created by James on 9/3/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

struct BillCalculator {
    var bill: Float = 0.0
    var tipPercent: Float = 0.0
    var split: Int = 1
    var billTotal: Float = 0.0
    
    init(bill: Float, tipPercent: Float, split: Int) {
        self.bill = bill; self.tipPercent = tipPercent; self.split = split
    }
    
    mutating func billCalculation() -> BillResult {
        
        billTotal = bill + (bill * tipPercent/100)
        
        var billResult = BillResult()
        
        billResult.billTotal = String(self.billTotal)
        billResult.split = String(self.split)
        billResult.tip   = String(Int(self.tipPercent))
        billResult.totalPerPerson = String(billTotal / Float(split))
        
        return billResult
    }
}
