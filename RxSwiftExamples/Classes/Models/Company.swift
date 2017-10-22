//
//  Company.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 19/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import Mapper

struct Company: Mappable {
    
    let symbol: String
    let companyName: String
    let exchange: String
    let industry: String
    let website: String
    let description: String
    let ceo: String
    let issueType: String
    let sector: String
    
    init(map: Mapper) throws {
        try symbol = map.from("symbol")
        try companyName = map.from("companyName")
        try exchange = map.from("exchange")
        try industry = map.from("industry")
        try website = map.from("website")
        try description = map.from("description")
        try ceo = map.from("CEO")
        try issueType = map.from("issueType")
        try sector = map.from("sector")
    }
    
}
