//
//  Observable+ModelMapper.swift
//  Pods
//
//  Created by sunshinejr on 03.02.2016.
//  Copyright © 2016 sunshinejr. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Mapper
#if !COCOAPODS
    import Moya_ModelMapper
#endif

/// Extension for processing Responses into Mappable objects through ObjectMapper
public extension ObservableType where E == Response {
    
    /// Maps data received from the signal into an object (on the default Background thread) which
    /// implements the Mappable protocol and returns the result back on the MainScheduler.
    /// If the conversion fails, the signal errors.
    public func map<T: Mappable>(to type: T.Type, keyPath: String? = nil) -> Observable<T> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<T> in
                return Observable.just(try response.map(to: type, keyPath: keyPath))
            }
            .observeOn(MainScheduler.instance)
    }
    
    /// Maps data received from the signal into an array of objects (on the default Background thread)
    /// which implement the Mappable protocol and returns the result back on the MainScheduler
    /// If the conversion fails, the signal errors.
    public func map<T: Mappable>(to type: [T].Type, keyPath: String? = nil) -> Observable<[T]> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<[T]> in
                return Observable.just(try response.map(to: type, keyPath: keyPath))
            }
            .observeOn(MainScheduler.instance)
    }
    
    /// Maps data received from the signal into an object (on the default Background thread) which
    /// implements the Mappable protocol and returns the result back on the MainScheduler.
    /// If the conversion fails, the nil is returned instead of error signal.
    public func mapOptional<T: Mappable>(to type: T.Type, keyPath: String? = nil) -> Observable<T?> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<T?> in
                do {
                    let object = try response.map(to: type, keyPath: keyPath)
                    return Observable.just(object)
                } catch {
                    return Observable.just(nil)
                }
                
            }
            .observeOn(MainScheduler.instance)
    }
    
    /// Maps data received from the signal into an array of objects (on the default Background thread)
    /// which implement the Mappable protocol and returns the result back on the MainScheduler
    /// If the conversion fails, the nil is returned instead of error signal.
    public func mapOptional<T: Mappable>(to type: [T].Type, keyPath: String? = nil) -> Observable<[T]?> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<[T]?> in
                do {
                    let object = try response.map(to: type, keyPath: keyPath)
                    return Observable.just(object)
                } catch {
                    return Observable.just(nil)
                }
            }
            .observeOn(MainScheduler.instance)
    }
}
