//
//  Logo.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 22/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import Mapper

struct Logo: Mappable {
    
    let url: String
    
    init(map: Mapper) throws {
        try url = map.from("url")
    }
    
}
