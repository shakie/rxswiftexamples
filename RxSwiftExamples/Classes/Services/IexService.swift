//
//  IexService.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 19/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Moya_ModelMapper

struct IexService {
    
    let provider = MoyaProvider<IexWebService>()
    
    func getSymbols() -> Observable<[Symbol]> {
        return provider.rx.request(.symbols)
            .filterSuccessfulStatusCodes()
            .observeOn(MainScheduler.instance)
            .map(to: [Symbol].self)
            .asObservable()
    }
    
}
