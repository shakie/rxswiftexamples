//
//  SymbolSection.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 19/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import RxDataSources

struct SymbolSection {
    var items: [Item]
}

extension SymbolSection: SectionModelType {
    typealias Item = Symbol
    
    init(original: SymbolSection, items: [Item]) {
        self = original
        self.items = items
    }
    
}
