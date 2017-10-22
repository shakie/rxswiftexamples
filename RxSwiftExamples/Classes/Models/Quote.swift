//
//  Quote.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 22/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import Mapper

struct Quote: Mappable {
    
    let latestPrice: Double
    let previousClose: Double
    let changePercent: Double
    let latestUpdate: Int
    
    init(map: Mapper) throws {
        try latestPrice = map.from("latestPrice")
        try previousClose = map.from("previousClose")
        try changePercent = map.from("changePercent")
        try latestUpdate = map.from("latestUpdate")
    }
    
}
