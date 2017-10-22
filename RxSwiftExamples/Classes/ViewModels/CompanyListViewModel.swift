//
//  CompanyListViewModel.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 20/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import RxSwift

class CompanyListViewModel: StatusPublisher {
    
    let service = IexService()
    let disposables = DisposeBag()
    let reachable = BehaviorSubject<Bool>(value: true)
    let dataSource = Variable<[SymbolSection]>([SymbolSection]())
    
    var symbols = [Symbol]()
    var statusPublisher = BehaviorSubject<Status>(value: Status(false))
    
    init() {
        setupReachabilityObservable()
    }
    
    func getSymbols() {
        reachable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] reachable in
                if reachable {
                    self?.publishStatus(Status(true, message: "Loading companies"))
                    self?.service.getSymbols().observeOn(MainScheduler.instance)
                        .map { $0.filter { $0.name.characters.count > 0 && $0.isEnabled } }
                        .subscribe(onNext: { [weak self] symbols in
                            self?.symbols = symbols
                            self?.updateDataSource(symbols)
                            self?.publishStatus(Status(false))
                        }, onError: { error in
                            if error.localizedDescription.contains("offline") {
                                self?.reachable.onNext(false)
                            }
                        }).disposed(by: self?.disposables ?? DisposeBag())
                }
            }).disposed(by: disposables)
    }
    
    func updateDataSource(_ symbols: [Symbol]) {
        dataSource.value = [SymbolSection(items: symbols)]
    }
    
    private func setupReachabilityObservable() {
        service.reachability.rx.isReachable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] reachable in
                self?.reachable.onNext(reachable)
            }).disposed(by: disposables)
    }
    
}
