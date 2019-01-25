//
//  RxUtil.swift
//  Example
//
//  Created by 王芃 on 2018/10/23.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift

extension ObservableType {
    func void() -> Observable<Void> {
        return map { _ in }
    }
    func startWith(_ factory: @escaping () -> Observable<E>) -> Observable<E> {
        let start = Observable<E>.deferred {
            factory()
        }
        return start.concat(self)
    }
}

public func handleError(_ err: Error) -> Error {
    switch err {
    case HttpClientError.clientSideError(let error):
        printError("Http Client Error \(error)")
        break
    case let HttpClientError.invalidResponse(response, data):
        printError("Server Error Response \(response), and returning data \(String(describing: data))")
        break
    case HttpClientError.invalidJsonObject:
        printError("Server returning an invalid json")
        break
    case HttpClientError.jsonDeserializationError(let err):
        printError("the json cannot be deserialized \(err)")
        break
    case SmartError.server(let data):
        printError("Server Error Response, and returning data \(String(describing: data))")
        break
    case SmartError.jdAccountNotBinded:
        printError("JD Account Not Binded")
        break
    case SmartError.tokenInvalid:
        printError("The access token is invalid")
        break
    case SmartError.jdTokenInvalid:
        printError("The JD access token is invalid")
        break
    default:
        break
    }
    return err
}
