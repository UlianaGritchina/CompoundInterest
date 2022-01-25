//
//  Results.swift
//  CompoundInterest
//
//  Created by Ульяна Гритчина on 25.01.2022.
//

import Foundation

struct Results {
    var results: [Int]
    var totalDeposits: Int
    var total: Int {
        results.last!
    }
    var profit: Int {
        results.last! - totalDeposits
    }
    
    var depositTime: [Int]
}

enum TimeTypes {
    case months
    case years
}
