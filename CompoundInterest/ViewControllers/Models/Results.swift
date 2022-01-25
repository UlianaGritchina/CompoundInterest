//
//  Results.swift
//  CompoundInterest
//
//  Created by Ульяна Гритчина on 25.01.2022.
//

import Foundation
struct Results {
    var period: Int
    var start: Float
    var mainResalt: Float
    var resalts: [Float]
    var sum: Float
    var proc: Float {
        mainResalt - sum - start
    }
}
