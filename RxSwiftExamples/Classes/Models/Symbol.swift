//
//  Symbol.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 19/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import Mapper

struct Symbol: Mappable {
    
    let symbol: String
    let name: String
    let date: String
    let isEnabled: Bool
    
    init(map: Mapper) throws {
        try symbol = map.from("symbol")
        try name = map.from("name")
        try date = map.from("date")
        try isEnabled = map.from("isEnabled")
    }
    
}
