//
//  TopsQuote.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 23/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import Mapper

struct TopsQuote: Mappable {
    
    let lastSalePrice: Double
    let lastUpdated: Int
    
    init(map: Mapper) throws {
        try lastSalePrice = map.from("lastSalePrice")
        try lastUpdated = map.from("lastUpdated")
    }
    
}
