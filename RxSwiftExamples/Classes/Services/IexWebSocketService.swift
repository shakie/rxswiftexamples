//
//  IexWebSocketService.swift
//  RxSwiftExamples
//
//  Created by Shaun Rowe on 21/10/2017.
//  Copyright © 2017 Shaun Rowe. All rights reserved.
//

import Foundation
import SocketIO
import RxSwift
import ReachabilitySwift
import RxReachability

struct IexWebSocketService {
    
    static let BASE_URL = "https://ws-api.iextrading.com/1.0/tops"
    let socket: SocketIOClient
    let reachability = ReachabilityService.getReachabilityForHostname(IexWebSocketService.BASE_URL)
    let connected = BehaviorSubject<Bool>(value: false)
    let quotePublisher = PublishSubject<TopsQuote>()
    
    init() {
        socket = SocketIOClient(socketURL: URL(string: IexWebSocketService.BASE_URL)!)
        setupListeners()
        socket.connect()
    }
    
    func subscribe(_ symbol: String) {
        socket.emit("subscribe", symbol)
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    private func setupListeners() {
        socket.on(clientEvent: .connect) { data , ack in
            self.connected.onNext(true)
        }
        socket.on("tops") { data, ack in
            let dict = data[0] as! [String: Any]
            if let quote = TopsQuote.from(dict as NSDictionary) {
                self.quotePublisher.onNext(quote)
            }
        }
    }
    
}
