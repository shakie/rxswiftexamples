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
import RxReachability
import ReachabilitySwift

struct IexService {
    
    static let BASE_URL = "https://api.iextrading.com/1.0"
    let provider = MoyaProvider<IexWebService>()
    let reachability = ReachabilityService.getReachabilityForHostname(IexService.BASE_URL)
    
    func getSymbols() -> Observable<[Symbol]> {
        return provider.rx.request(.symbols)
            .filterSuccessfulStatusCodes()
            .observeOn(MainScheduler.instance)
            .map(to: [Symbol].self)
            .asObservable()
    }
    
    func getCompany(_ symbol: String) -> Observable<Company> {
        return provider.rx.request(.company(symbol: symbol))
            .filterSuccessfulStatusCodes()
            .observeOn(MainScheduler.instance)
            .map(to: Company.self)
            .asObservable()
    }
    
    func getLogo(_ symbol: String) -> Observable<Logo> {
        return provider.rx.request(.logo(symbol: symbol))
            .filterSuccessfulStatusCodes()
            .observeOn(MainScheduler.instance)
            .map(to: Logo.self)
            .asObservable()
    }
    
    func getQuote(_ symbol: String) -> Observable<Quote> {
        return provider.rx.request(.quote(symbol: symbol))
            .filterSuccessfulStatusCodes()
            .observeOn(MainScheduler.instance)
            .map(to: Quote.self)
            .asObservable()
    }
    
}
