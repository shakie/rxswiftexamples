//
//  CompanyViewModel.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 19/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import RxSwift

struct CompanyViewModel: StatusPublisher {
    
    let apiService = IexService()
    let socketService = IexWebSocketService()
    let disposables = DisposeBag()
    let apiReachable = BehaviorSubject<Bool>(value: true)
    let webSocketReachable = BehaviorSubject<Bool>(value: true)
    
    let symbol = Variable<String>("")
    let companyName = Variable<String>("")
    let logo = Variable<String>("")
    let exchange = Variable<String>("")
    let industry = Variable<String>("")
    let website = Variable<String>("")
    let description = Variable<String>("")
    let ceo = Variable<String>("")
    let issueType = Variable<String>("")
    let sector = Variable<String>("")
    let latestPrice = Variable<Double>(0.00)
    let latestPriceFormatted = Variable<String>("")
    let closingPrice = Variable<Double>(0.00)
    let closingPriceFormatted = Variable<String>("")
    let difference = Variable<Double>(0.00)
    let differenceFormatted = Variable<String>("")
    let lastUpdated = Variable<String>("")
    
    var statusPublisher = BehaviorSubject<Status>(value: Status(false))
    
    init() {
        setupObservables()
    }
    
    func update(_ symbol: String) {
        apiReachable.observeOn(MainScheduler.instance)
            .subscribe(onNext: { reachable in
                if reachable {
                    self.publishStatus(Status(true, message: "Loading company"))
                    self.apiService.getCompany(symbol)
                        .subscribe(onNext: { company in
                            self.populate(company)
                        })
                        .disposed(by: self.disposables)
                }
            }, onError: { error in
                if error.localizedDescription.contains("offline") {
                    self.apiReachable.onNext(false)
                    self.webSocketReachable.onNext(false)
                }
            }).disposed(by: disposables)
    }
    
    func close() {
        socketService.disconnect()
    }
    
    private func populate(_ company: Company) {
        symbol.value = company.symbol
        companyName.value = company.companyName
        exchange.value = company.exchange
        industry.value = company.industry
        website.value = company.website
        description.value = company.description
        ceo.value = company.ceo
        issueType.value = company.issueType
        sector.value = company.sector
    }
    
    private func setupObservables() {
        setupPriceObservables()
        setupSymbolObservable()
        setupReachabilityObservable()
    }
    
    private func setupReachabilityObservable() {
        apiService.reachability.rx.isReachable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { reachable in
                self.apiReachable.onNext(reachable)
            }).disposed(by: disposables)
        
        socketService.reachability.rx.isReachable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { reachable in
                self.webSocketReachable.onNext(reachable)
            }).disposed(by: disposables)
    }
    
    private func setupSymbolObservable() {
        symbol.asObservable().observeOn(MainScheduler.instance)
            .subscribe(onNext: { symbol in
                if symbol.characters.count > 0 {
                    self.apiService.getQuote(symbol)
                        .subscribe(onNext: { quote in
                            self.latestPrice.value = quote.latestPrice
                            self.closingPrice.value = quote.previousClose
                            self.difference.value = quote.changePercent
                            self.updateLastUpdated(quote.latestUpdate / 1000)
                            self.publishStatus(Status(false))
                        }, onError: { error in
                            print("Error: \(error.localizedDescription)")
                        }).disposed(by: self.disposables)
                    
                    self.subscribeToRealTime(symbol)
                }
            }).disposed(by: disposables)
    }
    
    private func subscribeToRealTime(_ symbol: String) {
        Observable.combineLatest(socketService.connected, webSocketReachable)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [symbol] connected, reachable in
                if connected && reachable {
                    self.socketService.subscribe(symbol)
                }
            }).disposed(by: disposables)
    }
    
    private func setupTopsQuoteObservable() {
        socketService.quotePublisher.observeOn(MainScheduler.instance)
            .subscribe(onNext: { quote in
                self.latestPrice.value = quote.lastSalePrice
                let diff = ((quote.lastSalePrice - self.closingPrice.value) / self.closingPrice.value) * 100
                self.difference.value = diff
            }).disposed(by: disposables)
    }
    
    private func setupPriceObservables() {
        latestPrice.asObservable().observeOn(MainScheduler.instance)
            .subscribe(onNext: { price in
                self.latestPriceFormatted.value = self.formatCurrency(price, decimals: 2, code: "USD")
            }).disposed(by: disposables)
        
        closingPrice.asObservable().observeOn(MainScheduler.instance)
            .subscribe(onNext: { price in
                self.closingPriceFormatted.value = self.formatCurrency(price, decimals: 2, code: "USD")
            }).disposed(by: disposables)
        
        difference.asObservable().observeOn(MainScheduler.instance)
            .subscribe(onNext: { diff in
                self.differenceFormatted.value = self.formatDifference(diff, decimals: 5)
            }).disposed(by: disposables)
    }
    
    private func updateLastUpdated(_ ts: Int? = nil) {
        var date = Date()
        if let ts = ts {
            date = Date(timeIntervalSince1970: Double(ts))
        }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        lastUpdated.value = "\(formatter.string(from: date))"
    }
    
    private func formatCurrency(_ amount: Double, decimals: Int, code: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = decimals
        formatter.currencyCode = code
        formatter.locale = Locale.current
        
        return formatter.string(for: amount)!
    }
    
    private func formatDifference(_ diff: Double, decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.negativePrefix = "-"
        formatter.positivePrefix = "+"
        formatter.minimumIntegerDigits = 1
        formatter.locale = Locale.current
        
        return formatter.string(for: diff)!
    }
    
}
