//
//  IexWebService.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 19/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import Moya

enum IexWebService {
    case symbols
    case company(symbol: String)
    case logo(symbol: String)
    case quote(symbol: String)
}

extension IexWebService: TargetType {
    var baseURL: URL { return URL(string: IexService.BASE_URL)! }
    var path: String {
        switch self {
        case .symbols:
            return "/ref-data/symbols"
        case .company(let symbol):
            return "/stock/\(symbol)/company"
        case .logo(let symbol):
            return "/stock/\(symbol)/logo"
        case.quote(let symbol):
            return "/stock/\(symbol)/quote"
        }
    }
    var method: Moya.Method {
        switch self {
        case .symbols, .company, .logo, .quote:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .symbols, .company, .logo, .quote:
            return .requestPlain
        }
    }
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        return nil
    }
}
