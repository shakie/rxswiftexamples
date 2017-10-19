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
}

extension IexWebService: TargetType {
    var baseURL: URL { return URL(string: "https://api.iextrading.com/1.0")! }
    var path: String {
        switch self {
        case .symbols:
            return "/ref-data/symbols"
        }
    }
    var method: Moya.Method {
        switch self {
        case .symbols:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .symbols:
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
