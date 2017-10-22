//
//  ReachabilityService.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 20/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import RxSwift
import ReachabilitySwift
import RxReachability

struct ReachabilityService {
    
    static private var reachabilities = [String: Reachability]()
    
    static func getReachabilityForHostname(_ hostname: String) -> Reachability {
        if ReachabilityService.reachabilities[hostname] == nil {
           ReachabilityService.reachabilities[hostname] = Reachability(hostname: hostname)
        }
        
        return ReachabilityService.reachabilities[hostname]!
    }
    
}
