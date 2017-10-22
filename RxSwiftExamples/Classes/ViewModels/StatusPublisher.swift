//
//  StatusPublisher.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 22/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import RxSwift

protocol StatusPublisher {
    
    var statusPublisher: BehaviorSubject<Status> { get set }
    
    func publishStatus(_ status: Status)
    
}

extension StatusPublisher {
    
    func publishStatus(_ status: Status) {
        statusPublisher.onNext(status)
    }
    
}
