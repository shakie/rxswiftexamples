//
//  Status.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 22/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation

struct Status {
    
    let showHud: Bool
    let message: String?
    
    init(_ show: Bool, message: String? = nil) {
        self.showHud = show
        self.message = message
    }
    
}
